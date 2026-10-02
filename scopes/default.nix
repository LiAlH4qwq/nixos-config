# Scope registry for the strict-tree switch system.
#
# This is *settings*, not library code: it is evaluated on its own through the
# nixpkgs module system (`lib.evalModules`) so every field below is type-checked.
# `lib.liuxu` only consumes the evaluated result.
#
# A module in scope `<from>` may `premise` on a switch in scope `<to>` iff
# `scopes.<from>.deps.<to>` is declared.  `deps` is therefore the explicit DAG
# that makes cross-scope premises both possible and cycle-free.
#
# Cardinality is a property of the *edge*: the same `home` scope is many-valued
# from `nixos` (one per user) but single-valued from `nix-on-droid`.
{ lib, config, ... }:
let
  inherit (lib) types mkOption;

  depType = types.submodule {
    options = {
      cardinality = mkOption {
        type = types.enum [
          "one"
          "many"
        ];
        default = "one";
        description = "Whether the target scope has one or many instances.";
      };
      defaultQuant = mkOption {
        type = types.enum [
          "any"
          "all"
        ];
        default = "any";
        description = "Default quantifier used when cardinality is many.";
      };
      prefix = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = "Override for the path prefix of the target switch inside an instance config.";
      };
      instances = mkOption {
        type = types.nullOr (types.functionTo (types.listOf types.raw));
        default = null;
        description = "args -> list of instance configs; required when cardinality is many.";
      };
    };
  };
in
{
  options.namespace = mkOption {
    type = types.listOf types.str;
    default = [ "liuxu" ];
    description = "Global option namespace all scopes live under.";
  };

  options.scopes = mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          root = mkOption {
            type = types.listOf types.str;
            description = "Option path of this scope (relative to the module system root).";
          };
          deps = mkOption {
            type = types.attrsOf depType;
            default = { };
            description = "Scopes this scope may premise on.";
          };
        };
      }
    );
    default = { };
  };

  config.scopes = {
    fp = {
      root = config.namespace ++ [ "fp" ];
      deps = {
        nixos = { };
        nix-on-droid = { };
      };
    };

    nixos = {
      root = config.namespace ++ [ "nixos" ];
      deps = {
        home = {
          cardinality = "many";
          defaultQuant = "any";
          instances = args: builtins.attrValues args.config.home-manager.users;
        };
        id = { };
        system = { };
      };
    };

    nix-on-droid = {
      root = config.namespace ++ [ "nix-on-droid" ];
      deps = {
        home = {
          cardinality = "one";
          instances = args: [ args.config ];
        };
        id = { };
        system = { };
      };
    };

    home = {
      root = config.namespace ++ [ "home" ];
      deps = {
        id = { };
      };
    };

    id = {
      root = config.namespace ++ [ "id" ];
    };

    system = {
      root = config.namespace ++ [ "system" ];
    };
  };
}

# Concrete scope registry data for this configuration.
#
# The schema/types and the evaluation wiring live upstream in
# `nix-tree-modules` (`scopeModule` / `mkScopes`); this module only supplies the
# namespace and the per-scope roots/deps for this repo.
#
# A module in scope `<from>` may `premise` on a switch in scope `<to>` iff
# `scopes.<from>.deps.<to>` is declared.  `deps` is therefore the explicit DAG
# that makes cross-scope premises both possible and cycle-free.
#
# Cardinality is a property of the *edge*: the same `home` scope is many-valued
# from `nixos` (one per user) but single-valued from `nix-on-droid`.
{ config, ... }:
{
  config.namespace = [ "liuxu" ];

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
      root = [ ];
      internal = config.namespace ++ [
        "nix-on-droid"
        "internal"
      ];
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
      switches = false;
    };

    system = {
      root = config.namespace ++ [ "system" ];
    };

    device = {
      root = config.namespace ++ [ "device" ];
      switches = false;
      deps = {
        nixos = { };
        home = {
          cardinality = "many";
          defaultQuant = "any";
          instances = args: builtins.attrValues args.config.home-manager.users;
        };
        id = { };
        system = { };
      };
    };
  };
}

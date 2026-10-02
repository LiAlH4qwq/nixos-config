# Switch translation + cross-scope premise resolution.
#
# A strict-tree module declares its switch metadata through `here`:
#
#   { here = {
#       switch = { enable = true; default = false; premise = [ ... ]; };
#       options = { ... };   # extra options, placed under <scope-root>.<path>
#       config  = { ... };   # gated behind the computed final enable
#     };
#   }
#
# `here.switch` is optional.  When omitted the module is opt-in: the generated
# public `enable` defaults to `false` and gates `here.config`.
#
# and is translated to:
#
#   options.<root>.<path>.switch               (internal, type-checked)
#   options.<root>.<path>.enable               public switch
#   options.<root>.internal.final.<path>.enable = <own enable> && <premises>
#   config = mkIf <final> here.config
{ lib }:
let
  inherit (lib) types;

  # Type of a cross-scope switch reference.  `scope` is checked against the
  # registered scope names; `path` is relative to the target scope root.
  mkSwitchRefType =
    scopes:
    types.submodule {
      options = {
        scope = lib.mkOption {
          type = types.enum (builtins.attrNames scopes);
          description = "Scope the referenced switch lives in.";
        };
        path = lib.mkOption {
          type = types.listOf types.str;
          description = "Path of the switch relative to the target scope root.";
        };
        quant = lib.mkOption {
          type = types.enum [
            "any"
            "all"
          ];
          default = "any";
          description = "Quantifier when the target scope is many-valued.";
        };
      };
    };

  mkPremiseType =
    scopes:
    types.listOf (
      types.either types.str (types.either (types.listOf types.str) (mkSwitchRefType scopes))
    );

  mkSwitchOptionType =
    scopes:
    types.submodule {
      options = {
        enable = lib.mkOption {
          type = types.bool;
          default = true;
          description = "Gate the module config behind its computed final enable.";
        };
        default = lib.mkOption {
          type = types.bool;
          default = false;
          description = "Default of the public `enable` option (opt-in / opt-out).";
        };
        premise = lib.mkOption {
          type = mkPremiseType scopes;
          default = [ ];
          description = "Switches that must also be enabled for this one to be final.";
        };
        children = lib.mkOption {
          type = types.nullOr (
            types.either
              (types.enum [
                "any"
                "all"
              ])
              (
                types.submodule {
                  options = {
                    mode = lib.mkOption {
                      type = types.enum [
                        "any"
                        "all"
                      ];
                      default = "any";
                    };
                    of = lib.mkOption {
                      type = types.listOf types.str;
                      default = [ ];
                      description = "Child names to aggregate; empty means all direct child switches.";
                    };
                  };
                }
              )
          );
          default = null;
          description = "Aggregate direct child switches into this node's final enable.";
        };
      };
    };

  # Resolve a single premise (string / path list = same-scope shorthand, or a
  # switch ref) to a boolean.
  evalPremise =
    {
      scopes,
      from,
      args,
    }:
    premise:
    let
      # Direct edge from `from` to `to`, or a descriptive error.  Same-scope
      # references are always allowed.
      edgeOf =
        { from, to }:
        if from == to then
          { }
        else
          let
            fromScope = scopes.${from} or (throw "liuxu: unknown source scope '${from}'");
          in
          fromScope.deps.${to} or (throw "liuxu: premise ${from} -> ${to} is not in the declared scope DAG");

      ref =
        if builtins.isString premise then
          {
            scope = from;
            path = [ premise ];
          }
        else if builtins.isList premise then
          {
            scope = from;
            path = premise;
          }
        else
          premise;
      to = ref.scope;
      target = scopes.${to} or (throw "liuxu: unknown target scope '${to}'");
      edge = edgeOf { inherit from to; };
      prefix = if (edge.prefix or null) != null then edge.prefix else target.root;
      switchPath =
        prefix
        ++ [
          "internal"
          "final"
        ]
        ++ ref.path
        ++ [ "enable" ];
      get =
        cfg:
        if lib.hasAttrByPath switchPath cfg then
          lib.attrByPath switchPath false cfg
        else
          throw "liuxu: premise ${from} -> ${to} references missing switch '${lib.concatStringsSep "." switchPath}'";
      cardinality = edge.cardinality or "one";
      quant = ref.quant or edge.defaultQuant or "any";
      instances =
        if (edge.instances or null) != null then
          edge.instances args
        else if cardinality == "many" then
          throw "liuxu: premise ${from} -> ${to} is many-valued but the edge has no `instances`"
        else
          [ args.config ];
    in
    if cardinality == "many" then
      (if quant == "any" then lib.any else lib.all) get instances
    else
      get (builtins.head instances);

  # Translate one leaf module into a real module.
  translateModule =
    {
      scopes,
      scopeName,
      path,
      file,
      childPaths ? [ ],
    }:
    let
      scope = scopes.${scopeName} or (throw "liuxu: unknown scope '${scopeName}'");
      full = scope.root ++ path;
      finalPath =
        scope.root
        ++ [
          "internal"
          "final"
        ]
        ++ path;
      raw = import file;
      inner = if builtins.isFunction raw then raw else _: raw;
      innerArgs = lib.functionArgs inner;
      outerArgs = (builtins.removeAttrs innerArgs [ "this" ]) // {
        config = false;
        options = false;
      };
    in
    lib.setFunctionArgs (
      args@{ config, options, ... }:
      let
        this = {
          inherit file path;
          config = lib.attrByPath full { } config;
          options = lib.attrByPath full { } options;
        };
        result = inner (lib.intersectAttrs innerArgs args // { inherit this; });
        here = result.here or null;
      in
      if here == null then
        result
      else
        let
          sw = this.config.switch or { };
          gate = sw.enable or true;
          defaultOn = sw.default or false;
          premise = sw.premise or [ ];
          own = this.config.enable or defaultOn;
          premiseOk = lib.all (evalPremise {
            inherit scopes args;
            from = scopeName;
          }) premise;
          childFinalPath =
            cp:
            scope.root
            ++ [
              "internal"
              "final"
            ]
            ++ cp
            ++ [ "enable" ];
          childFinal =
            cp:
            if lib.hasAttrByPath (childFinalPath cp) config then
              lib.attrByPath (childFinalPath cp) false config
            else
              throw "liuxu: child aggregation references missing child switch '${lib.concatStringsSep "." (childFinalPath cp)}'";
          children = sw.children or null;
          aggregateOk =
            if children == null then
              true
            else
              let
                spec =
                  if builtins.isString children then
                    {
                      mode = children;
                      of = [ ];
                    }
                  else
                    children;
                selected = if spec.of != [ ] then map (n: path ++ [ n ]) spec.of else childPaths;
                vals = map childFinal selected;
              in
              if spec.mode == "all" then lib.all lib.id vals else lib.any lib.id vals;
          finalOn = own && premiseOk && aggregateOk;
        in
        {
          imports = result.imports or [ ];
          options =
            lib.recursiveUpdate
              (lib.recursiveUpdate
                (lib.setAttrByPath (full ++ [ "switch" ]) (
                  lib.mkOption {
                    type = mkSwitchOptionType scopes;
                    internal = true;
                    default = { };
                  }
                ))
                (
                  lib.setAttrByPath (full ++ [ "enable" ]) (
                    lib.mkOption {
                      type = types.bool;
                      default = defaultOn;
                    }
                  )
                )
              )
              (
                lib.recursiveUpdate (lib.setAttrByPath (finalPath ++ [ "enable" ]) (
                  lib.mkOption {
                    type = types.bool;
                    internal = true;
                    readOnly = true;
                    default = finalOn;
                  }
                )) (lib.setAttrByPath full (here.options or { }))
              );
          config = lib.mkMerge [
            (lib.setAttrByPath (full ++ [ "switch" ]) (here.switch or { }))
            (lib.mkIf (if gate then finalOn else true) (here.config or { }))
          ];
        }
    ) outerArgs;
in
{
  inherit
    mkSwitchRefType
    mkPremiseType
    mkSwitchOptionType
    evalPremise
    translateModule
    ;
}

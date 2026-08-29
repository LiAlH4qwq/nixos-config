{
  config,
  lib,
  root,
  ...
}:
{
  options.liuxu.fp.disallowed-inputs-deps = lib.mkOption {
    type = with lib.types; listOf str;
    default = [ ];
    example = [ "flake-compat" ];
    description = lib.liuxu.mkFpDesc ''
      Inputs dependencies that disallowed to introduce in this flake.
    '';
  };

  config =
    let
      cfg = config.liuxu.fp.disallowed-inputs-deps;
    in
    lib.mkIf (cfg != [ ]) {
      perSystem = { pkgs, ... }: {
        checks = {
          disallowed-inputs-deps = pkgs.writers.writeNuBin "disallowed-inputs-deps" (
            let
              mkYaml = config.flake.lib.liuxu.oo lib.escapeShellArg (pkgs.formats.yaml_1_2 { }).generate;
              inputs = root + "/flake.nix" |> import |> builtins.getAttr "inputs";
              allInputsDeps = inputs |> lib.mapAttrsToListRecursiveCond (_: v: (v ? inputs)) (p: _: lib.last p);
              pass = if (lib.intersectLists allInputsDeps cfg) == [ ] then "true" else "false";
            in
            ''
              let allInputsDeps = open ${mkYaml "allInputsDeps" allInputsDeps} | from yaml
              let disallowedInputsDeps = open ${mkYaml "disallowedInputsDeps" cfg} | from yaml
              let pass = ${pass}
              let check = {
                allInputsDeps: ($allInputsDeps)
                disallowedInputsDeps: ($disallowedInputsDeps)
                pass: ($pass)
              }
              echo $check | to json | save -f $env.out
            ''
          );
        };
      };
    };
}

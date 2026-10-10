{ config, root, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      results = import (root + "/nix-tree-modules/src/tests") { lib = config.flake.lib; };
      failed = builtins.filter (n: !results.${n}) (builtins.attrNames results);
    in
    {
      checks.nix-tree-modules-switch = pkgs.runCommand "nix-tree-modules-switch-test" { } (
        if failed == [ ] then
          "touch $out"
        else
          "echo 'nix-tree-modules switch test failures: ${builtins.concatStringsSep ", " failed}' >&2; exit 1"
      );
    };
}

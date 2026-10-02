{ config, root, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      results = import (root + "/lib/liuxu/tests") { lib = config.flake.lib; };
      failed = builtins.filter (n: !results.${n}) (builtins.attrNames results);
    in
    {
      checks.liuxu-switch = pkgs.runCommand "liuxu-switch-test" { } (
        if failed == [ ] then
          "touch $out"
        else
          "echo 'liuxu switch test failures: ${builtins.concatStringsSep ", " failed}' >&2; exit 1"
      );
    };
}

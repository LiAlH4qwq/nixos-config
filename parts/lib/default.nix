{
  inputs,
  lib,
  root,
  ...
}:
{
  flake.lib = lib.extend (
    _: prev: {
      inherit (inputs.nix-kdl) kdl;
      inherit (import (root + "/lib") prev) liuxu;
      inherit (inputs.home-manager.lib) hm;
    }
  );
}

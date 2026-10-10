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
      nix-tree-modules = inputs.nix-tree-modules.lib;
      inherit (import (root + "/lib") prev) liuxu;
      inherit (inputs.home-manager.lib) hm;
    }
  );
}

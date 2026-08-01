{
  inputs,
  lib,
  self,
  ...
}:
{
  flake.lib = lib.extend (
    _: prev: {
      inherit (inputs.nix-kdl) kdl;
      inherit (import "${self}/lib" prev) liuxu;
      inherit (inputs.home-manager.lib) hm;
    }
  );
}

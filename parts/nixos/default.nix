{
  inputs,
  lib,
  self,
  ...
}:
{
  flake = {
    nixosConfigurations =
      let
        mkHost =
          cfg:
          inputs.nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = lib.singleton "${self}/nixos" ++ lib.singleton cfg;
          };
      in
      {
        LiAlH4-Laptop = mkHost "${inputs.self}/devices/thinkbook-14-g4p-iap";
        LiAlH4-Server = mkHost "${inputs.self}/devices/htpc";
      };
  };
}

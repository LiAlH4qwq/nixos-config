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
            specialArgs = {
              inherit inputs self;
              inherit (self) lib;
            };
            modules = lib.singleton self.nixosModules.liuxu ++ lib.singleton cfg;
          };
      in
      {
        LiAlH4-Laptop = mkHost "${inputs.self}/devices/thinkbook-14-g4p-iap";
        LiAlH4-Server = mkHost "${inputs.self}/devices/htpc";
      };
  };
}

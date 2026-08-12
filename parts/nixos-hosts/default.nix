{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations =
    let
      mkHost =
        cfg:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs self;
            inherit (self) lib;
          };
          modules = [
            self.nixosModules.liuxu
            "${self}/devices/${cfg}"
          ];
        };
    in
    {
      Live-CD = mkHost "live-cd";
      LiAlH4-Laptop = mkHost "thinkbook-14-g4p-iap";
      LiAlH4-Server = mkHost "asus-h110t";
    };
}

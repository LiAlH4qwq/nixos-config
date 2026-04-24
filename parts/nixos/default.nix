{ inputs, ... }:
{
  flake = {
    nixosConfigurations =
      let
        specialArgs = { inherit inputs; };
        commons = [
          inputs.ragenix.nixosModules.default
          inputs.nixos-cli.nixosModules.default
          inputs.lanzaboote.nixosModules.default
          inputs.impermanence.nixosModules.default
          inputs.home-manager.nixosModules.default
          inputs.libpam-pwdfile-rs.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              overwriteBackup = true;
              backupFileExtension = "bak";
              # Home Manager will not consume specialArgs
              # unless explicitly pass it as this.
              extraSpecialArgs = specialArgs;
              sharedModules = [
                "${inputs.self}/user"
              ];
            };
          }
          {
            nixpkgs.overlays = [
              inputs.self.overlays.default
              inputs.rust-overlay.overlays.default
              inputs.deploy-rs.overlays.default
            ];
          }
          "${inputs.self}/nixos"
        ];
      in
      {
        LiAlH4-Laptop = inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = commons ++ [
            "${inputs.self}/devices/thinkbook-14-g4p-iap"
          ];
        };
        LiAlH4-Server = inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = commons ++ [
            "${inputs.self}/devices/htpc"
          ];
        };
      };
  };
}

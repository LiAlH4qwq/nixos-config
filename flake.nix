{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      lanzaboote,
      home-manager,
      ...
    }:
    {
      nixosConfigurations =
        let
          commons = [
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.default
            ./system
            ./users
          ]
          ++ modules;
          modules = [ ./system/modules ];
        in
        {
          thinkbook-14-g4p-iap = nixpkgs.lib.nixosSystem {
            modules = commons ++ [
              ./devices/thinkbook-14-g4p-iap
            ];
          };
        };
    };
}

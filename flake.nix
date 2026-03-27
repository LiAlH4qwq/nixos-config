{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs = {
        nixpkgs.follows = "";
        home-manager.follows = "";
      };
    };
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
    {
      nixpkgs,
      impermanence,
      lanzaboote,
      home-manager,
      ...
    }:
    {
      nixosConfigurations =
        let
          commons = [
            impermanence.nixosModules.impermanence
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

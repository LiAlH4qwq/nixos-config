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
    libpam-pwdfile-rs = {
      url = "github:lialh4qwq/libpam-pwdfile-rs/v0.2.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      nixpkgs,
      impermanence,
      lanzaboote,
      home-manager,
      libpam-pwdfile-rs,
      ...
    }:
    {
      nixosConfigurations =
        let

          # Reflects NixOS release version when system installed.
          # Do not change it unless needed.
          nixosReleaseVersionWhenInstalled = "25.11";

          commons = [
            impermanence.nixosModules.impermanence
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            libpam-pwdfile-rs.nixosModules.libpam-pwdfile-rs
            {
              home-manager.sharedModules = [
                {
                  home.stateVersion = nixosReleaseVersionWhenInstalled;
                }
                ./user
              ];
            }
            {
              # Reflects NixOS version when system installed.
              # Do not change it unless needed.
              system.stateVersion = nixosReleaseVersionWhenInstalled;
            }
            ./system
          ];
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

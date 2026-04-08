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
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs = {
        nixpkgs.follows = "";
        home-manager.follows = "";
      };
    };
    agenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    libpam-pwdfile-rs = {
      url = "github:lialh4qwq/libpam-pwdfile-rs/v0.4.0";
      # url = "path:/mnt/data/lialh4/Projects/libpam-pwdfile-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock-hint = {
      url = "path:/mnt/data/lialh4/Projects/nixos-config/packages/hyprlock-hint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      lanzaboote,
      home-manager,
      impermanence,
      agenix,
      libpam-pwdfile-rs,
      hyprlock-hint,
      ...
    }:
    {
      nixosConfigurations =
        let

          # Reflects NixOS release version when system installed.
          # Do not change it unless needed.
          nixosReleaseVersionWhenInstalled = "25.11";

          specialArgs = { inherit inputs; };
          commons = [
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            impermanence.nixosModules.impermanence
            agenix.nixosModules.default
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
              system.stateVersion = nixosReleaseVersionWhenInstalled;
            }
            {
              nixpkgs.overlays = [
                hyprlock-hint.overlays.default
              ];
            }
            ./system
          ];
        in
        {
          thinkbook-14-g4p-iap = nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            modules = commons ++ [
              ./devices/thinkbook-14-g4p-iap
            ];
          };
        };
    };
}

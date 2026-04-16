{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:yaxitech/ragenix";
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
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        nixosConfigurations =
          let

            # Reflects NixOS release version when system installed.
            # Do not change it unless needed.
            nixosReleaseVersionWhenInstalled = "25.11";

            specialArgs = { inherit inputs; };
            commons = [
              inputs.nixos-cli.nixosModules.nixos-cli
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.agenix.nixosModules.default
              inputs.home-manager.nixosModules.home-manager
              inputs.impermanence.nixosModules.impermanence
              inputs.libpam-pwdfile-rs.nixosModules.libpam-pwdfile-rs
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
                  inputs.hyprlock-hint.overlays.default
                ];
              }
              ./system
            ];
          in
          {
            LiAlH4-Laptop = inputs.nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              modules = commons ++ [
                ./devices/thinkbook-14-g4p-iap
              ];
            };
          };
      };
    };
}

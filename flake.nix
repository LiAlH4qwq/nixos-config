{
  inputs = {
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat.url = "github:NixOS/flake-compat";
    crane.url = "github:ipetkov/crane";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        systems.follows = "systems";
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "nix-darwin";
        home-manager.follows = "home-manager";
      };
    };
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        rust-overlay.follows = "rust-overlay";
        crane.follows = "crane";
        agenix.follows = "agenix";
      };
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # `flake-utils`.
        utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
      };
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        crane.follows = "crane";
        # Or it will fail to build.
        # rust-overlay.follows = "ragenix/crane";
        pre-commit.inputs.flake-compat.follows = "deploy-rs/flake-compat";
      };
    };
    lazyvim = {
      url = "github:pfassina/lazyvim-nix/v15.15.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    agl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-25.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        flake-compat.follows = "flake-compat";
      };
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs = {
        nixpkgs.follows = "";
        home-manager.follows = "";
      };
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    libpam-pwdfile-rs = {
      url = "github:lialh4qwq/libpam-pwdfile-rs/v0.4.0";
      # url = "path:/mnt/data/lialh4/Projects/libpam-pwdfile-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bun2nix = {
      url = "github:nix-community/bun2nix?ref=refs/tags/2.0.8";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
    };
  };
  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./parts
      ];
      systems = import inputs.systems;
    };
}

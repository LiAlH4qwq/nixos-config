{
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    nix-parsec.url = "github:milahu/nix-parsec";
    import-tree.url = "github:denful/import-tree";
    crane.url = "github:ipetkov/crane";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      # It's indeed Nixpkgs.
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-prelude = {
      url = "github:anna328p/nix-prelude";
      inputs = {
        systems.follows = "systems";
        parsec.follows = "nix-parsec";
      };
    };
    optnix = {
      url = "github:water-sucks/optnix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
      };
    };
    lazyvim = {
      url = "github:pfassina/lazyvim-nix/v15.15.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        treefmt-nix.follows = "";
      };
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        noctalia-qs.follows = "noctalia-qs";
      };
    };
    intransience = {
      url = "github:anna328p/intransience";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        nix-prelude.follows = "nix-prelude";
      };
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # `flake-utils`.
        utils.follows = "flake-utils";
        flake-compat.follows = "";
      };
    };
    agl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-25.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        rust-overlay.follows = "rust-overlay";
      };
    };
    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "";
        optnix.follows = "optnix";
      };
    };
    bun2nix = {
      url = "github:nix-community/bun2nix?ref=refs/tags/2.0.8";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
        import-tree.follows = "import-tree";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        systems.follows = "systems";
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
        home-manager.follows = "home-manager";
      };
    };
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        crane.follows = "crane";
        rust-overlay.follows = "rust-overlay";
        agenix.follows = "agenix";
      };
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        crane.follows = "crane";
        rust-overlay.follows = "rust-overlay";
        # It not used, so set it to empty.
        # See: https://github.com/nix-community/lanzaboote/blob/4eda91dd5abd2157a2c7bfb33142fc64da668b0a/flake.nix#L7
        pre-commit.follows = "";
      };
    };
    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # Absolutely `Nixpkgs`.
        # See: https://github.com/nix-community/nix-on-droid/blob/55b6449b4582a4ba3ce712543c973360a026db7d/flake.nix#L23
        nixpkgs-docs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        nmd.follows = "";
        nix-formatter-pack.follows = "";
      };
    };
    flat-flake = {
      url = "github:linyinfeng/flat-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
        crane.follows = "crane";
        rust-overlay.follows = "rust-overlay";
        flake-compat.follows = "";
      };
    };
    libpam-pwdfile-rs = {
      url = "github:lialh4qwq/libpam-pwdfile-rs/v0.4.0";
      # url = "path:/mnt/data/lialh4/Projects/libpam-pwdfile-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flat-flake.flakeModules.flatFlake
        ./parts
      ];
      systems = import inputs.systems;
      flatFlake.config.allowed = [
        # Not possible to flatten.
        # See: https://github.com/nix-community/nix-on-droid/blob/55b6449b4582a4ba3ce712543c973360a026db7d/flake.nix#L7
        [
          "nix-on-droid"
          "nixpkgs-for-bootstrap"
        ]
      ];
    };
}

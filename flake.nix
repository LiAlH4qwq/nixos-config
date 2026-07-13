let
  nixConfig = {
    extra-substituters = [
      "https://mirrors.nju.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://noctalia.cachix.org"
      "https://niri-nix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="
    ];
  };
in
{
  inherit nixConfig;
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    nix-kdl.url = "github:Lhcfl/nix-kdl";
    nix-parsec.url = "github:milahu/nix-parsec";
    crane.url = "github:ipetkov/crane";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    npm-lockfile-fix = {
      url = "github:jeslie0/npm-lockfile-fix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:niri-wm/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xwayland-satellite = {
      url = "github:Supreeeme/xwayland-satellite";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "";
      };
    };
    nix-prelude = {
      url = "github:anna328p/nix-prelude";
      inputs = {
        systems.follows = "systems";
        parsec.follows = "nix-parsec";
      };
    };
    lazyvim = {
      url = "github:pfassina/lazyvim-nix/v15.15.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pyproject-nix.follows = "pyproject-nix";
      };
    };
    niri-nix = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        niri-unstable.follows = "niri";
        xwayland-satellite-unstable.follows = "xwayland-satellite";
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
      url = "github:ezKEa/aagl-gtk-on-nix/release-26.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
        rust-overlay.follows = "rust-overlay";
      };
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        systems.follows = "systems";
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        darwin.follows = "";
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
      url = "github:nix-community/lanzaboote/v1.1.0";
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
    hermes = {
      url = "github:NousResearch/hermes-agent";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        pyproject-nix.follows = "pyproject-nix";
        uv2nix.follows = "uv2nix";
        npm-lockfile-fix.follows = "npm-lockfile-fix";
        # Tested, null-ok.
        pyproject-build-systems.follows = "";
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
      flake.nixConfig = nixConfig;
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

# Use Lix to eval.
let
  nixConfig = {
    extra-experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operator"
    ];
    extra-substituters = [
      # "https://mirrors.nju.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://noctalia.cachix.org"
      # inputs.agl
      "https://ezkea.cachix.org"
      "https://lialh4.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "lialh4.cachix.org-1:4j2YJj81SVMTyZWnEnMFnQ/I5j2g2IdFinQ8m9dv5c4="
    ];
  };
in
{
  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { config, ... }: {
        liuxu.fp.nixos = {
          sharedModules = [ config.flake.nixosModules.liuxu ];
          hosts = {
            LiAlH4-Laptop.modules = ./devices/thinkbook-14-g4p-iap;
            LiAlH4-Server.modules = ./devices/asus-h110t;
            LiAlH4-LiveCD.modules = ./devices/live-cd;
          };
        };
        flatFlake.config.allowed = [
          # Not possible to flatten.
          # See: https://github.com/nix-community/nix-on-droid/blob/55b6449b4582a4ba3ce712543c973360a026db7d/flake.nix#L7
          [
            "nix-on-droid"
            "nixpkgs-for-bootstrap"
          ]
        ];
        imports = [
          inputs.flat-flake.flakeModules.flatFlake
          inputs.github-actions-nix.flakeModules.default
          ./parts
        ];
        _module = {
          args.lib = config.flake.lib;
          specialArgs.root = ./.;
        };
        systems = import inputs.systems;
        flake.nixConfig = nixConfig;
        debug = true;
      }
    );
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
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-prelude = {
      url = "github:anna328p/nix-prelude";
      inputs = {
        systems.follows = "systems";
        parsec.follows = "nix-parsec";
      };
    };
    github-actions-nix = {
      url = "https://flakehub.com/f/synapdeck/github-actions-nix/*";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pyproject-nix.follows = "pyproject-nix";
      };
    };
    zen = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # Error when follows stable.
        nixpkgs.follows = "nixpkgs-unstable";
        home-manager.follows = "home-manager";
      };
    };
    peer-ban-helper = {
      # url = "/mnt/data/lialh4/Projects/peer-ban-helper-nix";
      url = "github:lialh4qwq/peer-ban-helper-nix";
      inputs = {
        systems.follows = "systems";
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
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
    agl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-26.05";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        flake-compat.follows = "";
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
    tg-transient = {
      url = "github:lialh4qwq/tg-transient";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
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
        # Tested, null-ok.
        nmd.follows = "";
        # Tested, null-ok.
        nix-formatter-pack.follows = "";
      };
    };
    hermes = {
      url = "github:NousResearch/hermes-agent/v2026.7.30";
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
        # Tested, null-ok.
        rust-overlay.follows = "";
        flake-compat.follows = "";
      };
    };
    libpam-pwdfile-rs = {
      url = "github:lialh4qwq/libpam-pwdfile-rs/v0.4.0";
      # url = "path:/mnt/data/lialh4/Projects/libpam-pwdfile-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

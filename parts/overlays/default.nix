{ inputs, ... }:
{
  flake = {
    overlays = {
      default = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) config system;
        };
        zellij = prev.zellij.override (old: {
          rustPlatform = final.makeRustPlatform {
            cargo = final.rust-bin.stable.latest.minimal;
            rustc = final.rust-bin.stable.latest.minimal;
          };
        });
      };
    };
  };
}

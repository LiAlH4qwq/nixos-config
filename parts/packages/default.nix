{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      pkgsWithBun2Nix = pkgs.extend inputs.bun2nix.overlays.default;
    in
    {
      packages.hitokoto = pkgsWithBun2Nix.callPackage "${inputs.self}/packages/hitokoto" { };
      packages.hyprlock-hint = pkgsWithBun2Nix.callPackage "${inputs.self}/packages/hyprlock-hint" { };
    };
  flake = {
    overlays = {
      default = final: prev: {
        hitokoto = inputs.self.packages.${prev.stdenv.hostPlatform.system}.hitokoto;
        hyprlock-hint = inputs.self.packages.${prev.stdenv.hostPlatform.system}.hyprlock-hint;
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

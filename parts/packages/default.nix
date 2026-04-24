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
      default = _: prev: {
        hitokoto = inputs.self.packages.${prev.stdenv.hostPlatform.system}.hitokoto;
        hyprlock-hint = inputs.self.packages.${prev.stdenv.hostPlatform.system}.hyprlock-hint;
        zellij = prev.zellij.override (old: {
          rustPlatform = prev.makeRustPlatform {
            cargo = prev.rust-bin.stable.latest.minimal;
            rustc = prev.rust-bin.stable.latest.minimal;
          };
        });
      };
    };
  };
}

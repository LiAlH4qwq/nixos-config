{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      pkgsWithBun2Nix = pkgs.extend inputs.bun2nix.overlays.default;
    in
    {
      packages.hyprlock-hint = pkgsWithBun2Nix.callPackage "${inputs.self}/packages/hyprlock-hint" { };
    };
}

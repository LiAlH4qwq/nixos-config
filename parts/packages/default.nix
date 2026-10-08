{ lib, root, ... }: {
  perSystem = { pkgs, system, ... }: {
    packages = {
      btop-theme-rose-pine-dawn = pkgs.callPackage (root + /packages/btop-theme-rose-pine-dawn) { };
      dangling-checker = pkgs.callPackage (root + /packages/dangling-checker) { };
      disable-dwt-in-hsr = pkgs.callPackage (root + /packages/disable-dwt-in-hsr) { };
      kill-focused-window = pkgs.callPackage (root + /packages/kill-focused-window) { };
      nushell-skill = pkgs.callPackage (root + /packages/nushell-skill) { };
      xwayland-xft-dpi = pkgs.callPackage (root + /packages/xwayland-xft-dpi) { };
    }
    // lib.optionalAttrs (system == "x86_64-linux") {
      # The images are x86_64-only (`meta.platforms`), so only expose the
      # package there; otherwise `nix flake check --all-systems` fails while
      # evaluating `packages.<other-system>.waydroid-lineage-vanilla`.
      waydroid-lineage-vanilla = pkgs.callPackage (root + /packages/waydroid-lineage-vanilla) { };
    };
  };
}

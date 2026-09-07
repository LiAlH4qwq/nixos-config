{ root, ... }: {
  perSystem = { pkgs, ... }: {
    packages = {
      btop-theme-rose-pine-dawn = pkgs.callPackage (root + /packages/btop-theme-rose-pine-dawn) { };
      dangling-checker = pkgs.callPackage (root + /packages/dangling-checker) { };
      disable-dwt-in-hsr = pkgs.callPackage (root + /packages/disable-dwt-in-hsr) { };
    };
  };
}

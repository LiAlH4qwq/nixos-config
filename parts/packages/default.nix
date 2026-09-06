{ root, ... }: {
  perSystem = { pkgs, ... }: {
    packages = {
      dangling-checker = pkgs.callPackage (root + /packages/dangling-checker) { };
      btop-theme-rose-pine-dawn = pkgs.callPackage (root + /packages/btop-theme-rose-pine-dawn) { };
    };
  };
}

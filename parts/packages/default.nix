{ root, ... }: {
  perSystem = { pkgs, ... }: {
    packages.dangling-checker = pkgs.callPackage (root + "/packages/dangling-checker") { };
  };
}

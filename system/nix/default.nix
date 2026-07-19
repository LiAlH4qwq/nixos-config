{ self, ... }: {
  imports = [
    ./lix
  ];
  nix.settings = {
    substituters = self.nixConfig.extra-substituters;
    trusted-public-keys = self.nixConfig.extra-trusted-public-keys;
    experimental-features = self.nixConfig.extra-experimental-features;
  };
}

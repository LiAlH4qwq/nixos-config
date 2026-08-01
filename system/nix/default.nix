{ self, ... }: {
  imports = [
    ./lix
  ];
  nix.settings =
    let
      substituters = self.nixConfig.extra-substituters;
    in
    {
      inherit substituters;
      trusted-substituters = substituters;
      trusted-public-keys = self.nixConfig.extra-trusted-public-keys;
      experimental-features = self.nixConfig.extra-experimental-features;
    };
}

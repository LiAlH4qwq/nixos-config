{ flakeConfig, ... }: {
  nix.settings =
    let
      cfg = flakeConfig.flake.nixConfig;
      substituters = cfg.extra-substituters;
    in
    {
      inherit substituters;
      trusted-substituters = substituters;
      trusted-public-keys = cfg.extra-trusted-public-keys;
      experimental-features = cfg.extra-experimental-features;
    };
}

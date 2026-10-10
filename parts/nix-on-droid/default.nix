{
  config,
  inputs,
  root,
  scopes,
  ...
}:
{
  flake = {
    nixOnDroidConfigurations = {
      default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        extraSpecialArgs = {
          inherit inputs root scopes;
          inherit (config.flake) lib;
          flakeConfig = config;
        };
        pkgs = import inputs.nixpkgs {
          system = "aarch64-linux";
          overlays = [ inputs.nix-on-droid.overlays.default ];
        };
        modules = [
          (root + "/nix-on-droid")
        ];
      };
    };
  };
}

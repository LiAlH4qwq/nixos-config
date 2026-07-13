{ inputs, self, ... }:
{
  flake = {
    nixOnDroidConfigurations = {
      default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        extraSpecialArgs = { inherit inputs self; };
        pkgs = import inputs.nixpkgs {
          system = "aarch64-linux";
          overlays = [ inputs.nix-on-droid.overlays.default ];
        };
        modules = [
          "${self}/nix-on-droid"
        ];
      };
    };
  };
}

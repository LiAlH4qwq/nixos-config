{ inputs, ... }:
{
  flake = {
    nixOnDroidConfigurations = {
      default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import inputs.nixpkgs {
          system = "aarch64-linux";
          overlays = [ inputs.nix-on-droid.overlays.default ];
        };
        modules = [
          inputs.ragenix.nixosModules.default
          "${inputs.self}/nix-on-droid"
        ];
      };
    };
  };
}

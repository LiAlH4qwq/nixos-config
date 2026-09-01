{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.nixos.brightness.enable = lib.liuxu.mkOsSwitchOnOption ''
    Whether to enable the brightness control support.
      Currently enables `brightnessctl`.
  '';

  config = lib.mkIf config.liuxu.nixos.brightness.enable {
    environment = {
      systemPackages = with pkgs; [
        brightnessctl
      ];
    };
    # Prevent brightness setting loss when rebooting.
    intransience.datastores.persist.dirs = [ "/var/lib/systemd/backlight" ];
  };
}

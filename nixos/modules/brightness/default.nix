{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.nixos.brightness.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable the brightness control support.
        Currently enables `brightnessctl`.
    '';
  };

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

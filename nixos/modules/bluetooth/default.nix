{ config, lib, ... }:
{
  options.liuxu.nixos.bluetooth.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable the bluetooth support.
        Currently enables bluez and enables blueman when GUI enabled.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    services.blueman.enable = config.liuxu.nixos.user-support.gui.enable;
  };
}

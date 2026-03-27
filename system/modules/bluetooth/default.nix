{ config, lib, ... }:
{
  options.liuxu.system.bluetooth.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable the bluetooth support.
        Currently enables bluez.
    '';
  };

  config = lib.mkIf config.liuxu.system.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
}

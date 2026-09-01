{ config, lib, ... }:
{
  options.liuxu.nixos.bluetooth.enable = lib.liuxu.mkOsSwitchOnOption ''
    Whether to enable the bluetooth support.
      Currently enables bluez and enables blueman when GUI enabled.
  '';

  config = lib.mkIf config.liuxu.nixos.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    services.blueman.enable = config.liuxu.nixos.internal.user-support.gui.enable;
  };
}

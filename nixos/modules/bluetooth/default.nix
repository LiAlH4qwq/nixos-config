{ config, ... }:
{
  here = {
    config = {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
      };
      services.blueman.enable = config.liuxu.nixos.internal.final.internal.user-support.gui.enable;
    };
  };
}

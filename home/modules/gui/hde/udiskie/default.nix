{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.internal.final.gui.enable {
    services.udiskie = {
      enable = true;
      automount = false;
    };
  };
}

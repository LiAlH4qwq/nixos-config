{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    services.udiskie = {
      enable = true;
      automount = false;
    };
  };
}

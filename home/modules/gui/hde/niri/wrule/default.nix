{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.gui.niri.enable {
    wayland.windowManager.niri.settings.window-rule = [
      {
        open-maximized = true;
        open-fullscreen = false;
      }
    ];
  };
}

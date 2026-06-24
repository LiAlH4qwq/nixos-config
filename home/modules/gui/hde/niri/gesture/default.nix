{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.gui.niri.enable {
    wayland.windowManager.niri.settings.gestures = {
    };
  };
}

{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.internal.final.gui.enable {
    programs.noctalia.settings.bar.default = {
      margin_edge = 0;
      margin_ends = 0;
      radius = 0;
      shadow = false;
      scale = 1.2;
      start = [
        "cpu"
        "cpu-temp"
        "workspaces"
        "active_window"
      ];
      center = [
        "clock"
        "notifications"
      ];
      end = [
        "media"
        "tray"
        "caffeine"
        "bluetooth"
        "network"
        "volume"
        "brightness"
        "battery"
      ];
    };
  };
}

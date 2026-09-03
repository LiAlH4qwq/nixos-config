{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    programs.noctalia.settings.widget = {
      active_window.title_scroll = "on_hover";
      brightness.show_label = false;
      clock.anchor = true;
      cpu-temp = {
        type = "sysmon";
        stat = "cpu_temp";
      };
      media.hide_when_no_media = true;
      network.show_label = false;
      notifications.hide_when_no_unread = true;
      volume.show_label = false;
      tray = {
        drawer = true;
        pinned = [
          "Fcitx"
          "udiskie"
        ];
      };
    };
  };
}

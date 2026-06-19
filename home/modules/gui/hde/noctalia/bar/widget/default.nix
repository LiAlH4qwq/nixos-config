{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    programs.noctalia.settings.widget = {
      brightness.show_label = false;
      clock.anchor = true;
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

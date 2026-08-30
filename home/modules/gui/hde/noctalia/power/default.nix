{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    programs.noctalia.settings = {
      idle.behavior = {
        screen-off = {
          action = "screen_off";
          timeout = 300;
        };
        lock = {
          action = "lock";
          timeout = 360;
        };
        suspend = {
          action = "suspend";
          timeout = 900;
        };
      };
      shell.session.actions = [
        {
          action = "lock";
          shortcut = "1";
        }
        {
          action = "logout";
          command = "hyprshutdown || niri msg action quit || umbriel msg session-quit";
          shortcut = "2";
        }
        {
          action = "lock_and_suspend";
          shortcut = "3";
        }
        {
          action = "command";
          command = "systemctl hibernate";
          shortcut = "4";
          glyph = "hibernate";
          label = "Hibernate";
        }
        {
          action = "reboot";
          command = "hyprshutdown -p reboot || reboot";
          shortcut = "5";
        }
        {
          action = "shutdown";
          command = "hyprshutdown -p poweroff || poweroff";
          shortcut = "6";
          variant = "destructive";
        }
      ];
    };
  };
}

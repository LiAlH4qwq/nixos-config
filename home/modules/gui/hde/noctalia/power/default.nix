{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    programs.noctalia.settings =
      let
        mkEnabledEntry = e: e // { enabled = true; };
      in
      {
        idle = {
          behavior_order = [
            "lock"
            "screen-off"
            "suspend"
          ];
          behavior = builtins.mapAttrs (_: mkEnabledEntry) {
            lock = {
              action = "lock";
              timeout = 300;
            };
            screen-off = {
              action = "screen_off";
              timeout = 360;
            };
            suspend = {
              action = "suspend";
              timeout = 900;
            };
          };
        };
        shell.session.actions = map mkEnabledEntry [
          {
            action = "lock";
            shortcut = "1";
            variant = "default";
          }
          {
            action = "logout";
            command = "hyprshutdown || niri msg action quit";
            shortcut = "2";
            variant = "default";
          }
          {
            action = "lock_and_suspend";
            shortcut = "3";
            variant = "default";
          }
          {
            action = "command";
            command = "systemctl hibernate";
            shortcut = "4";
            variant = "default";
            glyph = "hibernate";
            label = "Hibernate";
          }
          {
            action = "reboot";
            command = "hyprshutdown -p reboot || reboot";
            shortcut = "5";
            variant = "default";
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

{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.user.gui.enable {
    wayland.windowManager.hyprland.settings =
      let
        mod = "SUPER";
        ipc = "qs -c noctalia-shell ipc call";
      in
      {
        bind = [
          "${mod}, R, execr, ${ipc} launcher toggle"
          "${mod}, V, execr, ${ipc} launcher clipboard"
          "${mod}, L, execr, ${ipc} lockScreen lock"
          ", Help, execr, ${ipc} powerProfile cycle"
        ];
        bindl = [
          ", XF86AudioMute, execr, ${ipc} volume muteOutput"
          ", XF86AudioMicMute, execr, ${ipc} volume muteInput"
        ];
        bindle = [
          ", XF86AudioRaiseVolume, execr, ${ipc} volume increase"
          ", XF86AudioLowerVolume, execr, ${ipc} volume decrease"
          ", XF86MonBrightnessUp, execr, ${ipc} brightness increase"
          ", XF86MonBrightnessDown, execr, ${ipc} brightness decrease"
        ];

      };
  };
}

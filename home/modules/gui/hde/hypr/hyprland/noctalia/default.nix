{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.home.gui.enable {
    wayland.windowManager.hyprland.settings =
      let
        mod = "SUPER";
        noctalia = "noctalia-shell";
        ipc = "${noctalia} ipc call";
      in
      {
        execr-once = [ "uwsm-app -s s -t service -u uwsm-service-noctalia.service -- ${noctalia}" ];
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

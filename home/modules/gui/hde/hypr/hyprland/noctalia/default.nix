{
  config,
  lib,
  lib',
  ...
}:
{
  config = lib.mkIf config.liuxu.home.gui.enable (
    let
      noctalia = "noctalia-shell";
    in
    {
      liuxu.home.internal.gui.autostart = lib.singleton noctalia;
      wayland.windowManager.hyprland.settings =
        let
          ipc = "${noctalia} ipc call";
        in
        {
          bind = with lib'.liuxu.hyprland; [
            (mkNormalExecrBind "${ipc} launcher toggle" "SUPER + R")
            (mkNormalExecrBind "${ipc} launcher clipboard" "SUPER + V")
            (mkNormalExecrBind "${ipc} lockScreen lock" "SUPER + L")
            (mkNormalExecrBind "${ipc} powerProfile cycle" "Help")
            (mkLockedExecrBind "${ipc} volume muteOutput" "XF86AudioMute")
            (mkLockedExecrBind "${ipc} volume muteInput" "XF86AudioMicMute")
            (mkLockedRepeatingExecrBind "${ipc} volume increase" "XF86AudioRaiseVolume")
            (mkLockedRepeatingExecrBind "${ipc} volume decrease" "XF86AudioLowerVolume")
            (mkLockedRepeatingExecrBind "${ipc} brightness increase" "XF86MonBrightnessUp")
            (mkLockedRepeatingExecrBind "${ipc} brightness decrease" "XF86MonBrightnessDown")
          ];
        };
    }
  );
}

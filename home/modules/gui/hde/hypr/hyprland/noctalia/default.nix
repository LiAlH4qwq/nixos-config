{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.liuxu.home.gui.enable (
    let
      noctalia = "noctalia";
    in
    {
      liuxu.home.internal.gui.autostart = lib.singleton noctalia;
      wayland.windowManager.hyprland.settings =
        let
          ipc = "${noctalia} msg";
        in
        {
          bind = with lib.liuxu.hyprland; [
            (mkNormalExecrBind "${ipc} panel-toggle session" "SUPER + Delete")
            (mkNormalExecrBind "${ipc} panel-toggle launcher" "SUPER + R")
            (mkNormalExecrBind "${ipc} panel-toggle clipboard" "SUPER + V")
            (mkNormalExecrBind "${ipc} session lock" "SUPER + L")
            (mkNormalExecrBind "${ipc} power-cycle" "Help")
            (mkLockedExecrBind "${ipc} volume-mute" "XF86AudioMute")
            (mkLockedExecrBind "${ipc} mic-mute" "XF86AudioMicMute")
            (mkLockedRepeatingExecrBind "${ipc} volume-up" "XF86AudioRaiseVolume")
            (mkLockedRepeatingExecrBind "${ipc} volume-down" "XF86AudioLowerVolume")
            (mkLockedRepeatingExecrBind "${ipc} brightness-up" "XF86MonBrightnessUp")
            (mkLockedRepeatingExecrBind "${ipc} brightness-down" "XF86MonBrightnessDown")
          ];
          gesture = [
            {
              fingers = 3;
              direction = "down";
              action = lib.generators.mkLuaInline ''
                function()
                  hl.exec_cmd("${ipc} screenshot-fullscreen")
                end
              '';
            }
          ];
        };
    }
  );
}

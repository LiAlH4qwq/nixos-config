{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.liuxu.home.internal.gui.enable (
    let
      noctalia = [ "noctalia" ];
    in
    {
      liuxu.home = {
        internal.gui.autostart = lib.singleton noctalia;
        gui.keybinds.execr =
          let
            ipc = noctalia ++ [ "msg" ];
            mkExecrBind' = lib.flip lib.liuxu.wm.mkExecrBind;
            mkIpcBind' =
              let
                f = v: ipc ++ v;
              in
              lib.liuxu.compose mkExecrBind' f;
            mkIpcBind = lib.flip mkIpcBind';
            mkNormalIpcBind = mkIpcBind { };
            mkLockedIpcBind = mkIpcBind { lock = true; };
            mkLockedRepeatingIpcBind = mkIpcBind {
              lock = true;
              repeat = true;
            };
          in
          [
            (mkNormalIpcBind [ "panel-toggle" "session" ] "Delete" "Mod")
            (mkNormalIpcBind [ "panel-toggle" "launcher" ] "R" "Mod")
            (mkNormalIpcBind [ "panel-toggle" "clipboard" ] "V" "Mod")
            (mkNormalIpcBind [ "session" "lock" ] "L" "Mod")
            (mkNormalIpcBind [ "power-cycle" ] "Help" [ ])
            (mkLockedIpcBind [ "volume-mute" ] "XF86AudioMute" [ ])
            (mkLockedIpcBind [ "mic-mute" ] "XF86AudioMicMute" [ ])
            (mkLockedRepeatingIpcBind [ "volume-up" ] "XF86AudioRaiseVolume" [ ])
            (mkLockedRepeatingIpcBind [ "volume-down" ] "XF86AudioLowerVolume" [ ])
            (mkLockedRepeatingIpcBind [ "brightness-up" ] "XF86MonBrightnessUp" [ ])
            (mkLockedRepeatingIpcBind [ "brightness-down" ] "XF86MonBrightnessDown" [ ])
          ];
      };
    }
  );
}

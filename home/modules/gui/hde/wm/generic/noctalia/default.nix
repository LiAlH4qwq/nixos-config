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
      liuxu.home.gui = {
        autostart = lib.singleton noctalia;
        keybinds.execr =
          let
            mkIpcBind =
              let
                f =
                  let
                    ipc = noctalia ++ [ "msg" ];
                  in
                  v: ipc ++ v;
              in
              lib.liuxu.on2 lib.liuxu.wm.mkExecrBind f;
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

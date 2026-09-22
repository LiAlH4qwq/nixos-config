{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.liuxu.home.internal.gui.enable (
    let
      noctalia = [ "noctalia" ];
      ipc = noctalia ++ [ "msg" ];
      bind =
        {
          cmd,
          key,
          mod ? [ ],
          opts ? { },
        }:
        {
          inherit key mod opts;
          args.cmd = ipc ++ cmd;
        };
    in
    {
      liuxu.home.gui.wm = {
        keybinds.execr = [
          (bind {
            cmd = [
              "panel-toggle"
              "session"
            ];
            key = "Delete";
            mod = "Mod";
          })
          (bind {
            cmd = [
              "panel-toggle"
              "launcher"
            ];
            key = "R";
            mod = "Mod";
          })
          (bind {
            cmd = [
              "panel-toggle"
              "clipboard"
            ];
            key = "V";
            mod = "Mod";
          })
          (bind {
            cmd = [
              "session"
              "lock"
            ];
            key = "L";
            mod = "Mod";
          })
          (bind {
            cmd = [ "power-cycle" ];
            key = "Help";
          })
          (bind {
            cmd = [ "volume-mute" ];
            key = "XF86AudioMute";
            opts.lock = true;
          })
          (bind {
            cmd = [ "mic-mute" ];
            key = "XF86AudioMicMute";
            opts.lock = true;
          })
          (bind {
            cmd = [ "volume-up" ];
            key = "XF86AudioRaiseVolume";
            opts = {
              lock = true;
              repeat = true;
            };
          })
          (bind {
            cmd = [ "volume-down" ];
            key = "XF86AudioLowerVolume";
            opts = {
              lock = true;
              repeat = true;
            };
          })
          (bind {
            cmd = [ "brightness-up" ];
            key = "XF86MonBrightnessUp";
            opts = {
              lock = true;
              repeat = true;
            };
          })
          (bind {
            cmd = [ "brightness-down" ];
            key = "XF86MonBrightnessDown";
            opts = {
              lock = true;
              repeat = true;
            };
          })
        ];
      };
    }
  );
}

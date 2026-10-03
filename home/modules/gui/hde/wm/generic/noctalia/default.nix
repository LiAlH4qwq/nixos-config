{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.liuxu.home.internal.final.gui.enable (
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
      liuxu.home.gui.wm.keybinds.execr = [
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
          cmd = [ "caffeine-toggle" ];
          key = "Help";
        })
        (bind {
          cmd = [ "power-cycle" ];
          key = "Help";
          mod = "Shift";
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
        (bind {
          cmd = [
            "media"
            "play"
          ];
          key = "XF86PickupPhone";
          opts.lock = true;
        })
        (bind {
          cmd = [
            "media"
            "pause"
          ];
          key = "XF86HangupPhone";
          opts.lock = true;
        })
        (bind {
          cmd = [
            "media"
            "previous"
          ];
          key = "XF86PickupPhone";
          mod = [ "Shift" ];
          opts.lock = true;
        })
        (bind {
          cmd = [
            "media"
            "next"
          ];
          key = "XF86HangupPhone";
          mod = [ "Shift" ];
          opts.lock = true;
        })
      ];
    }
  );
}

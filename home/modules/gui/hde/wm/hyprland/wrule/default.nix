{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.home.gui.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      # No border, rounding, shadow when only one window.
      workspace_rule = [
        {
          workspace = "w[tv1]";
          gaps_in = 0;
          gaps_out = 0;
        }
        {
          workspace = "f[1]";
          gaps_in = 0;
          gaps_out = 0;
        }
      ];
      window_rule = [
        # No border, rounding, shadow when only one window,
        # mimics the maximize of Windows.
        {
          match.workspace = "w[tv1]";
          border_size = 0;
          rounding = 0;
          no_shadow = true;
        }
        {
          match.workspace = "f[1]";
          border_size = 0;
          rounding = 0;
          no_shadow = true;
        }
        # Ignore maximize request of all windows.
        {
          match.initial_class = ".*";
          suppress_event = "maximize";
        }
        # Pin Firefox PIP window to the right buttom cornor.
        # I don't know why,
        # but calced position like 100%-w(weight) 100%-h(height)
        # just doesn't work,
        # maybe it doesn't support lazy evaluation like nix :(
        {
          match = {
            initial_class = "^firefox$";
            initial_title = "^Picture-in-Picture$";
          };
          float = true;
          pin = true;
          size = [
            "(monitor_w*0.25)"
            "(monitor_h*0.25)"
          ];
          move = [
            "(monitor_w*0.75)"
            "(monitor_h*0.75)"
          ];
        }
        # Make settings window of Clementine float,
        # otherwise it'll misbehave.
        {
          match = {
            initial_class = "^org.clementine_player.Clementine$";
            initial_title = "^Preferences$";
          };
          float = true;
        }
        # Fix 💩 tencent meeting.
        {
          match = {
            initial_class = "^wemeetapp$";
            initial_title = "^wemeetapp$";
          };
          float = true;
        }
      ];
      on = [
        {
          _args = [
            "window.active"
            (lib.generators.mkLuaInline ''
              function(w)
                if w.class == "steam_proton" and w.title == "崩坏：星穹铁道" then
                  hl.config({
                    input = {
                      touchpad = {
                        disable_while_typing = false
                      }
                    }
                  })
                else
                  hl.config({
                    input = {
                      touchpad = {
                        disable_while_typing = true
                      }
                    }
                  })
                end
              end
            '')
          ];
        }
      ];
    };
  };
}

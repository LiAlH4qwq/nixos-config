{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.home.gui.enable {
    wayland.windowManager.hyprland.settings = {
      # No border, rounding, shadow when only one window.
      workspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];
      windowrule = [
        # No border, rounding, shadow when only one window,
        # mimics the maximize of Windows.
        "border_size 0, rounding 0, no_shadow on, match:float 0, match:workspace w[tv1]"
        "border_size 0, rounding 0, no_shadow on, match:float 0, match:workspace f[1]"
        # Ignore maximize request of all windows.
        "suppress_event maximize, match:initial_class .*"
        # Pin Firefox PIP window to the right buttom cornor.
        # I don't know why,
        # but calced position like 100%-w(weight) 100%-h(height)
        # just doesn't work,
        # maybe it doesn't support lazy evaluation like nix :(
        "float on, pin on, size 25% 25%, move 75% 75%, match:initial_class ^firefox$, match:initial_title ^Picture-in-Picture$"
        # Make settings window of Clementine float,
        # otherwise it'll misbehave.
        "float on, match:initial_class ^org.clementine_player.Clementine$, match:initial_title ^Preferences$"
        # File selection window of WPS will strangely
        # move itself to the right buttom cornor in Hyprland💩.
        "move 50%-50%w 50%-50%h, match:initial_class ^wpsoffice$, match:initial_title ^wpsoffice$"
      ];
    };
  };
}

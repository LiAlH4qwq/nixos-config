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
        "noborder, floating:0, onworkspace:w[tv1]"
        "noborder, floating:0, onworkspace:f[1]"
        "norounding, floating:0, onworkspace:w[tv1]"
        "norounding, floating:0, onworkspace:f[1]"
        "noshadow, floating:0, onworkspace:w[tv1]"
        "noshadow, floating:0, onworkspace:f[1]"
        # Ignore maximize request of all windows.
        "suppressevent maximize, class:.*"
        # Pin Firefox PIP window to the right buttom cornor.
        # I don't know why,
        # but calced position like 100%-w(weight) 100%-h(height)
        # just doesn't work,
        # maybe it doesn't support lazy evaluation like nix :(
        "float, pin, size 25% 25%, move 75% 75%, initialClass:^firefox$, initialTitle:^Picture-in-Picture$"
        # Make settings window of Clementine float,
        # otherwise it'll misbehave.
        "float, initialClass:^org.clementine_player.Clementine$, initialTitle:^Preferences$"
        # File selection window of WPS will strangely
        # move itself to the right buttom cornor in Hyprland💩.
        "move 50%-50%w 50%-50%h, initialClass:^wpsoffice$, initialTitle:^wpsoffice$"
      ];
    };
  };
}

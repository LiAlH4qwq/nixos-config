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
        "noborder, floating:0, onworkspace:w[tv1]"
        "noborder, floating:0, onworkspace:f[1]"
        "norounding, floating:0, onworkspace:w[tv1]"
        "norounding, floating:0, onworkspace:f[1]"
        "noshadow, floating:0, onworkspace:w[tv1]"
        "noshadow, floating:0, onworkspace:f[1]"
        "suppressevent maximize, class:.*"
        # I don't know why,
        # but calced position like 100%-w(weight) 100%-h(height)
        # just doesn't work,
        # maybe it doesn't support lazy evaluation like nix :(
        "float, pin, size 25% 25%, move 75% 75%, initialClass:^firefox$, initialTitle:^Picture-in-Picture$"
        "float, initialClass:^org.clementine_player.Clementine$, initialTitle:^Preferences$"
      ];
    };
  };
}

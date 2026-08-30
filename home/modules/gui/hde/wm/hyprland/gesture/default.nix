{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.home.gui.hyprland.enable {
    wayland.windowManager.hyprland.settings.gesture = [
      {
        fingers = 3;
        direction = "horizontal";
        action = "scroll_move";
      }
      {
        fingers = 3;
        direction = "vertical";
        action = "workspace";
      }
    ];
  };
}

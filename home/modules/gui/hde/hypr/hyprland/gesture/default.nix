{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.home.gui.enable {
    wayland.windowManager.hyprland.settings.gesture = [
      {
        fingers = 3;
        direction = "horizontal";
        action = "workspace";
      }
    ];
  };
}

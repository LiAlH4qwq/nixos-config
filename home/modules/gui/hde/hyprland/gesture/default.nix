{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.home.gui.hyprland.enable {
    wayland.windowManager.hyprland.settings.gesture = [
      {
        fingers = 3;
        direction = "horizontal";
        action = "workspace";
      }
      {
        fingers = 3;
        direction = "down";
        action = lib.generators.mkLuaInline ''
          function()
            hl.exec_cmd("noctalia msg screenshot-fullscreen")
          end
        '';
      }

    ];
  };
}

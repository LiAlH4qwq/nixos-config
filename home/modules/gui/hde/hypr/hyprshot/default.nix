{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.home.gui.enable {
    programs.hyprshot.enable = true;
    wayland.windowManager.hyprland.settings =
      let
        cmd = "hyprshot -o ${loc} -zm";
        loc = "$HOME/Pictures/Screenshots";
      in
      {
        gesture = [
          {
            fingers = 3;
            direction = "down";
            action = lib.generators.mkLuaInline ''
              function()
                hl.dsp.exec_raw("${cmd} output -m active")
              end
            '';
          }
        ];
      };
  };
}

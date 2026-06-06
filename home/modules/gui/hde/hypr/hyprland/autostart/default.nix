{ config, lib, ... }:
{
  options.liuxu.home.internal.gui.autostart = lib.mkOption {
    internal = true;
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config = lib.mkIf config.liuxu.home.gui.enable {
    # Fix fcitx5 won't work.
    liuxu.home.internal.gui.autostart = lib.singleton "fcitx5 -rd";
    wayland.windowManager.hyprland.settings.on._args = [
      "hyprland.start"
      (lib.generators.mkLuaInline ''
        function()
          ${
            map (e: ''hl.exec_cmd("${e}")'') config.liuxu.home.internal.gui.autostart
            |> lib.concatStringsSep "\n  "
          } 
        end
      '')
    ];
  };
}

{ config, lib, ... }:
{
  options.liuxu.home.internal.gui.autostart = lib.mkOption {
    internal = true;
    type = lib.types.listOf lib.types.str;
    default = [ ];
  };

  config = lib.mkIf config.liuxu.home.gui.hyprland.enable {
    liuxu.home.internal.gui.autostart = [
      # Fix fcitx5 won't work.
      "fcitx5 -rd"
      "1password --silent"
    ];
    wayland.windowManager.hyprland.settings.on = map (e: {
      _args = [
        "hyprland.start"
        (lib.generators.mkLuaInline ''
          function()
            hl.exec_cmd("${e}")
          end
        '')
      ];
    }) config.liuxu.home.internal.gui.autostart;
  };
}

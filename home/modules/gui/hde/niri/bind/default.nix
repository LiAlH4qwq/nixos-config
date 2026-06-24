{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.gui.niri.enable {
    wayland.windowManager.niri.settings.binds = with lib.liuxu.niri; {
      "Mod+Q" = mkNormalBind { close-window = [ ]; };
      "Mod+F" = mkNormalBind { toggle-window-floating = [ ]; };
      "Mod+Equal" = mkRepeatingBind { set-column-width = "+5%"; };
      "Mod+Minus" = mkRepeatingBind { set-column-width = "-5%"; };
      "Mod+M" = mkNormalBind { maximize-column = [ ]; };
    };
  };
}

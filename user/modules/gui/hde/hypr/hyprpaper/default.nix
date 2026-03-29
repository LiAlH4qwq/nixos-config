{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.user.gui.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        # I don't know why it needs old config style.
        preload = "~/Pictures/Wallpapers/rainy-everything-in-the-night.png";
        wallpaper = ", ~/Pictures/Wallpapers/rainy-everything-in-the-night.png";
      };
    };
  };
}

{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.user.gui.enable {
    services.hyprpaper = {
      enable = true;
      settings =
        let
          path = "/etc/wallpapers/rainy-everything-in-the-night.png";
        in
        {
          # I don't know why it needs old config style.
          preload = path;
          wallpaper = ", ${path}";
        };
    };
  };
}

{ config, lib, ... }:
{
  imports = [
    ./autostart
    ./bind
    ./noctalia
    ./gesture
    ./wrule
  ];

  config = lib.mkIf config.liuxu.home.gui.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      systemd = {
        enable = true;
        enableXdgAutostart = true;
      };
      settings = {
        config = {
          misc = {
            # Fallback to anime wallpaper when hyprpaper fails.
            force_default_wallpaper = 2;
          };
          general = {
            border_size = 4;
            gaps_in = 0;
            gaps_out = 0;
            "col.active_border" = "0xffd7827e";
            "col.inactive_border" = "0xff9893a5";
          };
          input = {
            natural_scroll = true;
            touchpad.natural_scroll = true;
          };
        };
      };
    };
  };
}

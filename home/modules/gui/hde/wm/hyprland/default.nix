{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./bind
    ./gesture
    ./wrule
  ];

  options.liuxu.home.gui.hyprland.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu (Home): Whether to enable the Hyprland GUI.
    '';
  };

  config = lib.mkIf config.liuxu.home.gui.hyprland.enable {
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
            layout = "scrolling";
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
    home.packages = with pkgs; [
      hyprnome
      hyprshutdown
    ];
  };
}

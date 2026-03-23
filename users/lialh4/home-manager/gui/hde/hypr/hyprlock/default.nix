_: {
  programs.hyprlock = {
    enable = true;
    settings =
      let
        # Rose Pine Dawn Theme
        # Source: https://rosepinetheme.com/palette/
        colors = {
          base = "0xfffaf4ed";
          surface = "0xfffffaf3";
          text = "0xff575279";
        };
      in
      {
        background = [
          {
            blur_passes = 3;
            # Fallback background color.
            color = colors.base;
            path = "~/Pictures/Wallpapers/rainy-everything-in-the-night.png";
          }
        ];
        label = [
          # Time
          {
            font_size = 128;
            color = "0xffffffff";
            position = "0, 30%";
            text = "cmd[update:1000] date +%H:%M";
          }
          # Date
          {
            font_size = 32;
            color = "0xffffffff";
            position = "0, 45%";
            text = "cmd[update:1000] date +%A,\ %B\ %d";
          }
        ];
        # Avatar
        image = [
          {
            size = 300;
            border_size = 0;
            shadow_passes = 3;
            position = "0, 0%";
            path = "~/Pictures/Avatar.jpg";
          }
        ];
        input-field = [
          {
            fade_on_empty = false;
            shadow_passes = 3;
            inner_color = colors.surface;
            position = "0, -15%";
          }
        ];
      };
  };
}

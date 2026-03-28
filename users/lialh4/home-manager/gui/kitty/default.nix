# Rose Pine Dawn theme
# Source: https://github.com/rose-pine/kitty/blob/582d0d0d1acf8c41ff8b4bde77f55946a4027c5e/dist/rose-pine-dawn.conf
_: {
  programs.kitty = {
    enable = true;
    settings = rec {
      font_size = 12;
      "map ctrl+c" = "copy_and_clear_or_interrupt";
      "map ctrl+v" = "paste_from_clipboard";
      foreground = "#575279";
      background = "#faf4ed";
      selection_foreground = foreground;
      selection_background = "#dfdad9";
      cursor = foreground; # Modified to make cursor visible
      cursor_text_color = foreground;
      url_color = color5;
      active_tab_foreground = foreground;
      active_tab_background = color0;
      inactive_tab_foreground = color8;
      inactive_tab_background = background;
      active_border_color = color2;
      inactive_border_color = selection_background;
      # black
      color0 = "#f2e9e1";
      color8 = "#9893a5";
      # red
      color1 = "#b4637a";
      color9 = color1;
      # green
      color2 = "#286983";
      color10 = color2;
      # yellow
      color3 = "#ea9d34";
      color11 = color3;
      # blue
      color4 = "#56949f";
      color12 = color4;
      # magenta
      color5 = "#907aa9";
      color13 = color5;
      # cyan
      color6 = "#d7827e";
      color14 = color6;
      # white
      color7 = foreground;
      color15 = foreground;
    };
  };
}

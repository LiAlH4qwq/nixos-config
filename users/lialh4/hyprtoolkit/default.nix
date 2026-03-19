# Rose Pine Dawn Theme
# Source: https://rosepinetheme.com/palette/
# Relation: Hyprtoolkit color <--> Rose Pine Dawn color
# background <--> Base
# base <--> Surface
# text <--> Text
# alternate_base <--> Overlay
# bright_text <--> Iris
# accent <--> Rose
# accent_secondary <--> Love

_: {
  home-manager.users.lialh4.home.file.hyprtoolkit = {
    target = ".config/hypr/hyprtoolkit.conf";
    text = ''
      background = 0xfffaf4ed
      base = 0xfffffaf3
      text = 0xff575279
      alternate_base = 0xfff2e9e1
      bright_text = 0xff907aa9
      accent = 0xffd7827e
      accent_secondary = 0xffb4637a
    '';
  };
}
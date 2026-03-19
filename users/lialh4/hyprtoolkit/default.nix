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
    target = "./config/hypr/hyprtoolkit.conf";
    text = ''
      background = #fffaf4ed
      base = #fffffaf3
      text = #ff575279
      alternate_base = #fff2e9e1
      bright_text = #ff907aa9
      accent = #ffd7827e
      accent_secondary = #ffb4637a
    '';
  };
}
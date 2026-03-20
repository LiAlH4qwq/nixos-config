# Rose Pine Dawn Theme
# Source: https://rosepinetheme.com/palette/
# Relation: Hyprtoolkit color <--> Rose Pine Dawn color
# text <--> Text
# background.base <--> Base
# background.weak <--> Surface
# background.strong <--> Overlay
# primary <--> Rose
# secondary <--> Love

{
  appearance = {
    # scale_factor = 1.5;
    style = "Solid";
    opacity = 0.75;
    text_color = "#575279";
    primary_color = "#d7827e";
    secondary_color = "#b4637a";
    background_color = {
      base = "#faf4ed";
      strong = "#f2e9e1";
      weak = "#fffaf3";
    };
  };
  modules = {
    left = [
      "Workspaces"
      "SystemInfo"
    ];
    center = [
      "Clock"
      "WindowTitle"
    ];
    right = [
      "MediaPlayer"
      "Tray"
      "Settings"
    ];
  };
  system_info = {
    indicators = [
      "Cpu"
      "Memory"
      "Temperature"
    ];
  };
}

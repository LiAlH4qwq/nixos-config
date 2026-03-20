{
  appearance = {
    # scale_factor = 1.5;
    style = "Solid";
    # opacity = 0.8;
    background_color = {
      base = "#faf4ed";
      strong = "#faf4ed";
      weak = "#faf4ed";
      text = "#faf4ed";
    };
    text_color = {
      base = "#575279";
      strong = "#575279";
      weak = "#575279";
      text = "#575279";
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

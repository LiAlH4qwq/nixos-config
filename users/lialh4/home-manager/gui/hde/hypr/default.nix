_: {
  imports = [
    ./hypridle
    ./hyprland
    ./hyprlock
    ./hyprpaper
    ./hyprshot
    ./hyprtoolkit
  ];

  services = {
    hyprpolkitagent.enable = true;
  };
}

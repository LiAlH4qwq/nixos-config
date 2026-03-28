_: {
  imports = [
    ./hypridle
    ./hyprland
    ./hyprlock
    ./hyprnome
    ./hyprpaper
    ./hyprshot
    ./hyprtoolkit
  ];

  services = {
    hyprpolkitagent.enable = true;
  };
}

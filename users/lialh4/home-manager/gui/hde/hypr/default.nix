_: {
  imports = [
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

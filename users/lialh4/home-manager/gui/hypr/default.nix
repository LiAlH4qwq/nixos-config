_: {
  imports = [
    ./hyprland
    ./hyprpaper
    ./hyprshot
    ./hyprtoolkit
  ];

  services = {
    hyprpolkitagent.enable = true;
  };
}

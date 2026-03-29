{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hypridle
    ./hyprland
    ./hyprlock
    ./hyprpaper
    ./hyprshot
    ./hyprtoolkit
  ];

  config = lib.mkIf config.liuxu.user.gui.enable {
    services = {
      hyprpolkitagent.enable = true;
    };

    home.packages = with pkgs; [
      hyprnome
    ];
  };
}

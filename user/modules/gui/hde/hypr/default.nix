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

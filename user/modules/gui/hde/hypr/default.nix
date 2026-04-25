{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
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

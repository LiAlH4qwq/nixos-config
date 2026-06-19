{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hyprland
    ./hyprtoolkit
  ];

  config = lib.mkIf config.liuxu.home.gui.enable {
    home.packages = with pkgs; [
      hyprnome
      hyprshutdown
    ];
  };
}

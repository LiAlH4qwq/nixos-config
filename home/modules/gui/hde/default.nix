{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./gtk
    ./hyprland
    ./hyprtoolkit
    ./i18n
    ./niri
    ./noctalia
    ./qt
    ./udiskie
    ./xcursor
  ];
  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    home.packages = with pkgs; [
      hyprshutdown
      wl-clipboard-rs # Clipboard
    ];
  };
}

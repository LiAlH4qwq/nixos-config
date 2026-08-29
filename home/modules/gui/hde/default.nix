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
    ./kdeconnect
    ./mime
    ./niri
    ./noctalia
    ./qt
    ./udiskie
    ./wm
    ./xcursor
  ];
  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    home.packages = with pkgs; [
      wl-clipboard-rs # Clipboard
    ];
  };
}

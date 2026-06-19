{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./gtk
    ./hypr
    ./i18n
    ./noctalia
    ./qt
    ./udiskie
    ./xcursor
  ];
  config = lib.mkIf config.liuxu.home.gui.enable {
    home.packages = with pkgs; [
      wl-clipboard-rs # Clipboard
    ];
  };
}

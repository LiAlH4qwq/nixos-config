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
    ./xcursor
  ];
  config = lib.mkIf config.liuxu.user.gui.enable {
    # services.gnome-keyring.enable = true;
    home.packages = with pkgs; [
      # `org.gnome.keyring.SystemPrompter`.
      # See: https://wiki.nixos.org/wiki/Secret_Service
      # gcr
      wl-clipboard-rs # Clipboard
    ];
  };
}

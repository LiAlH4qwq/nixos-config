{ lib, pkgs, ... }:
{
  imports = [
    ./ashell
    ./hypr
    ./i18n
    ./mako
    ./vicinae
    ./xcursor
  ];

  gtk = rec {
    enable = true;
    colorScheme = "light";
    theme = gtk4.theme;
    iconTheme = gtk4.iconTheme;
    # gtk4 needs to force enable.
    gtk4 = {
      enable = true;
      theme = {
        name = "rose-pine-dawn";
        package = pkgs.rose-pine-gtk-theme;
      };
      iconTheme = {
        name = "rose-pine-dawn";
        package = pkgs.rose-pine-icon-theme;
      };
    };
  };
  qt = rec {
    enable = true;
    platformTheme.name = "qtct";
    qt5ctSettings = qt6ctSettings;
    qt6ctSettings = {
      Appearance = {
        style = "kvantum";
        icon_theme = "rose-pine-dawn";
        standar_dialogs = "xdgdesktopportal";
      };
    };
  };
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = lib.generators.toINI { } {
      General = {
        theme = "rose-pine-dawn-iris";
      };
    };
    "Kvantum/rose-pine-dawn-iris".source =
      "${pkgs.rose-pine-kvantum}/share/Kvantum/themes/rose-pine-dawn-iris";
  };
  home.packages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    kdePackages.elisa
  ];
}

{ pkgs, ... }:
{
  imports = [
    ./ashell
    ./hypr
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
}

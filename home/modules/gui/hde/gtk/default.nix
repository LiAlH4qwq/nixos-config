{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.liuxu.home.gui.enable {
    gtk =
      let
        enable = true;
        colorScheme = "light";
        theme = {
          name = "rose-pine-dawn";
          package = pkgs.rose-pine-gtk-theme;
        };
        iconTheme = {
          name = "rose-pine-dawn";
          package = pkgs.rose-pine-icon-theme;
        };
      in
      {
        inherit
          enable
          colorScheme
          theme
          iconTheme
          ;
        # gtk4 needs to force enable.
        gtk4 = {
          inherit
            enable
            colorScheme
            theme
            iconTheme
            ;
        };
      };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    qt =
      let
        qtctSettings = {
          Appearance = {
            style = "kvantum";
            icon_theme = "rose-pine-dawn";
          };
        };
      in
      {
        enable = true;
        platformTheme.name = "qtct";
        qt5ctSettings = qtctSettings;
        qt6ctSettings = qtctSettings;
        kvantum = {
          enable = true;
          settings.General.theme = "rose-pine-dawn-iris";
          themes = with pkgs; [ rose-pine-kvantum ];
        };
      };
  };
}

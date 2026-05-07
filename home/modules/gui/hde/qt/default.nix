{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.liuxu.home.gui.enable {
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
      };
    xdg.configFile =
      let
        theme = "rose-pine-dawn-iris";
      in
      {
        "Kvantum/kvantum.kvconfig".text = lib.generators.toINI { } {
          General = {
            inherit theme;
          };
        };
        "Kvantum/${theme}".source = "${pkgs.rose-pine-kvantum}/share/Kvantum/themes/${theme}";
      };
    home.packages = with pkgs; [
      kdePackages.qtstyleplugin-kvantum
    ];
  };
}

{ pkgs, ... }: {
  programs.btop = {
    enable = true;
  };

  xdg.configFile.btop-theme-rose-pine-dawn = {
    target = "btop/themes/rose-pine-dawn.theme";
    source = "${pkgs.btop-theme-rose-pine-dawn}/share/btop/themes/rose-pine-dawn.theme";
  };
}

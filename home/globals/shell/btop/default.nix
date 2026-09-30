{ pkgs, ... }: {
  programs.btop = {
    enable = true;
    settings = {
      proc_aggregate = true;
      proc_filter_kernel = true;
      save_config_on_exit = false;
    };
  };

  xdg.configFile.btop-theme-rose-pine-dawn = {
    target = "btop/themes/rose-pine-dawn.theme";
    source = "${pkgs.btop-theme-rose-pine-dawn}/share/btop/themes/rose-pine-dawn.theme";
  };
}

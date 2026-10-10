{ pkgs, ... }: {
  here = { };
  programs.btop = {
    enable = true;
    settings = {
      proc_aggregate = true;
      proc_filter_kernel = true;
      proc_gradient = false;
      save_config_on_exit = false;
    };
  };

  xdg.configFile.btop-theme-rose-pine-dawn = {
    target = "btop/themes/rose-pine-dawn.theme";
    source = "${pkgs.btop-theme-rose-pine-dawn}/share/btop/themes/rose-pine-dawn.theme";
  };
}

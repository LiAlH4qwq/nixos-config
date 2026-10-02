{ config, pkgs, ... }:
{
  here = {
    switch = {
      default = true;
      premise = [
        {
          scope = "home";
          path = [
            "gui"
            "hyprland"
          ];
        }
      ];
    };
    config.programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}

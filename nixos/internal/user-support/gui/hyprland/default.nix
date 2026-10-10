_: {
  here = {
    switch = {
      generate = true;
      default = true;
      premise = {
        scope = "home";
        path = [
          "gui"
          "hyprland"
        ];
      };
    };
    apply.programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}

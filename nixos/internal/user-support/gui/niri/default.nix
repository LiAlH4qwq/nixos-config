_: {
  here = {
    switch = {
      default = true;
      premise = [
        {
          scope = "home";
          path = [
            "gui"
            "niri"
          ];
        }
      ];
    };
    config.programs.niri.enable = true;
  };
}

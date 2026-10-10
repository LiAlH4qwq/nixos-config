_: {
  here = {
    switch = {
      generate = true;
      default = true;
      premise = {
        scope = "home";
        path = [
          "gui"
          "niri"
        ];
      };
    };
    apply.programs.niri.enable = true;
  };
}

_: {
  here = {
    switch = {
      generate = true;
      default = true;
      premise = {
        scope = "home";
        path = [
          "gui"
          "opt"
        ];
      };
    };
    apply.programs.steam.enable = true;
  };
}

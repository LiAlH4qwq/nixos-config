_: {
  here = {
    switch = {
      default = true;
      premise = [
        {
          scope = "home";
          path = [
            "gui"
            "zen"
          ];
        }
      ];
    };
    config.environment.etc.zen-1password = {
      target = "1password/custom_allowed_browsers";
      text = "zen";
      # Execute bit required.
      mode = "0755";
    };
  };
}

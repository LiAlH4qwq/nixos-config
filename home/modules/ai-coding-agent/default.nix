_: {
  here = {
    switch = {
      default = true;
      children = {
        mode = "any";
        of = [
          "opencode"
          "pi"
        ];
      };
    };
    config.services.opencode-sanitizer.settings.rules.tw-flag = {
      pattern = "🇹🇼";
      literal = true;
    };
  };
}

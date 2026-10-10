_: {
  here = {
    switch = {
      generate = true;
      default = true;
      premise = {
        any = [
          [
            "here"
            "opencode"
          ]
          [
            "here"
            "pi"
          ]
        ];
      };
    };
    apply.services.opencode-sanitizer.settings.rules.tw-flag = {
      pattern = "🇹🇼";
      literal = true;
    };
  };
}

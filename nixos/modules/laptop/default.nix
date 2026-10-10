_: {
  here = {
    switch.generate = true;
    apply.services.upower = {
      enable = true;
      # Let loginctl handles lid events.
      ignoreLid = true;
    };
  };
}

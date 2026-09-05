_: {
  users.users.live = {
    isNormalUser = true;
    group = "wheel";
    password = "live";
  };

  home-manager.users.live = {
    liuxu.home = {
      gui = {
        umbriel.enable = true;
        opt.enable = false;
        zen.enable = false;
      };
      opencode.enable = true;
    };
  };
}

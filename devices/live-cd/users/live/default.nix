_: {
  users.users.live = {
    isNormalUser = true;
    group = "wheel";
    password = "live";
  };

  home-manager.users.live = {
    liuxu.home = {
      ai-coding-agent.opencode.enable = true;
      gui = {
        opt.enable = false;
        umbriel.enable = true;
        zen.enable = false;
      };
    };
  };
}

_: {
  users.users.live = {
    isNormalUser = true;
    group = "wheel";
    password = "live";
  };

  home-manager.users.live = {
    liuxu.home = {
      gui = {
        hyprland.enable = true;
        niri.enable = true;
        zen.enable = true;
      };
      opencode.enable = true;
    };
  };
}

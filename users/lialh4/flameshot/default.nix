_: {
  home-manager.users.lialh4.services.flameshot = {
    enable = true;
    settings = {
      General = {
        disabledTrayIcon = true;
        startupLaunch = false;
        showStartupLaunchMessage = false;
      };
    };
  };
}

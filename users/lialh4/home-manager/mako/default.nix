_: {
  home-manager.users.lialh4 = {
    services.mako = {
      enable = true;
      settings = {
        background-color = "#f2e9e1";
        text-color = "#575279";
        border-color = "#cecacd";
        progress-color = "over #286983";
        "urgency=high" = {
          border-color = "#b4637a";
        };
        default-timeout = 10000;
        font = "Sans 12";
        border-size = 4;
        border-radius = 10;
      };
    };
    # Notification sound.
    # home.file.noti-sound = {
    #   target = ".local/share/sounds/notification.ogg";
    #   source = "./notification.ogg";
    # };
  };
}

_: {
  imports = [
    ./perl-less
    ./python-less
  ];

  services = {
    # Better D-Bus implemention.
    dbus.implementation = "broker";
    # Use Chrony for better experience, especially on laptop.
    timesyncd.enable = false;
    chrony.enable = true;
  };

  security = {
    sudo.enable = false;
    sudo-rs.enable = true;
    polkit = {
      enable = true;
      # allow users to shutdown or reboot computer.
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        });
      '';
    };
  };
}

{ pkgs, ... }:
{
  imports = [
    ./state
    ./fonts
    ./i18n
  ];

  nixpkgs.config.allowUnfree = true;

  boot.plymouth.enable = true;

  # replace sudo with run0.
  security = {
    sudo.enable = false;
    polkit = {
      enable = true;
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

  networking = {
    networkmanager.enable = true;

    # allow tun mode traffic.
    firewall = {
      checkReversePath = false;
      trustedInterfaces = [
        "mihoyo"
      ];
    };
  };

  services = {
    dbus.implementation = "broker";
    # displayManager.gdm.enable = true;
    openssh.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  # i hate bash btw.
  programs = {
    fish.enable = true;

    # these programs can't simply be enabled only in the user scope.
    _1password-gui.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    clash-verge = {
      enable = true;
      autoStart = true;
      serviceMode = true;
      tunMode = true;
    };
  };
}

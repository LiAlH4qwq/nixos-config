{ pkgs, ... }:
{
  imports = [
    ./state
    ./boot
    ./i18n
    ./nix
    ./persist
  ];

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };
  };

  security = {
    # replace sudo with run0.
    sudo.enable = false;
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
    power-profiles-daemon.enable = true;
    openssh.enable = true;
    pipewire = {
      enable = true;
      socketActivation = true;
      audio.enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };

  programs = {
    # i hate bash btw.
    fish.enable = true;

    nix-ld = {
      enable = true;
    };

    # these programs can't simply be enabled only in the user scope.
    _1password-gui.enable = true;
    steam.enable = true;
    hyprlock.enable = true;
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

  environment.systemPackages = with pkgs; [
    usbutils # `lsusb`
  ];
}

{ inputs, pkgs, ... }:
{
  imports = [
    "${inputs.self}/system"
    ./boot
    ./i18n
    ./modules
    ./nix
    ./persist
  ];

  programs = {
    # Used by `nixos-rebuild`
    git.enable = true;
    nix-ld = {
      enable = true;
    };
  };
  services = {
    # userborn.enable = true;
    # Better D-Bus implemention.
    dbus.implementation = "broker";
    power-profiles-daemon.enable = true;
    # Use Chrony for better experience, especially on laptop.
    timesyncd.enable = false;
    chrony.enable = true;
  };

  environment.systemPackages = [
    pkgs.usbutils # `lsusb`
  ];

  # No more states.
  users = {
    mutableUsers = false;
  };

  # system.etc.overlay = {
  #   enable = true;
  #   # mutable = false;
  # };

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

  hardware = {
    enableRedistributableFirmware = true;
  };
}

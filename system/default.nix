{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./i18n
    ./modules
    ./nix
    ./secrets
    ./uutils
  ];

  # No more states.
  users = {
    mutableUsers = false;
  };

  hardware = {
    enableRedistributableFirmware = true;
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

  services = {
    # userborn.enable = true;
    # Better D-Bus implemention.
    dbus.implementation = "broker";
    power-profiles-daemon.enable = true;
    # Use Chrony for better experience, especially on laptop.
    timesyncd.enable = false;
    chrony.enable = true;
  };

  programs = {
    # Used by `nixos-rebuild`
    git.enable = true;
    nix-ld = {
      enable = true;
    };
  };

  system.etc.overlay = {
    # enable = true;
    # Otherwise it will break,
    # since some files in `/etc` are binded mount from `/persist`,
    # somes are tmpfiles only alive in runtime.
    # Neither of them are awared by nix,
    # so mutable should be allowed.
    # mutable = true;
  };

  environment.systemPackages = [
    pkgs.usbutils # `lsusb`
    pkgs.deploy-rs.deploy-rs
    # FIXME: Write a overlay or use a presented one if possible.
    inputs.ragenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

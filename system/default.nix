{ pkgs, ... }:
{
  imports = [
    ./boot
    ./i18n
    ./modules
    ./nix
    ./persist
  ];

  users = {
    mutableUsers = false;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    overwriteBackup = true;
    backupFileExtension = "bak";
  };

  hardware = {
    enableRedistributableFirmware = true;
  };

  libpam-pwdfile-rs = {
    pin = {
      pwdfile = "/etc/pin";
      services = [ "polkit-1" ];
      users = {
        lialh4.secret = "2f5e034b65504c52cbc4e575431d4d3888c1cdb66702b426ccacc33f0df3aea1d84de715959abe6d7a29b73d75ca608aa5c7c30c6aaafbcbb284a0bc0ab9e6df";
      };
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

  services = {
    dbus.implementation = "broker";
    power-profiles-daemon.enable = true;
    openssh.enable = true;
  };

  programs = {
    nix-ld = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    usbutils # `lsusb`
  ];
}

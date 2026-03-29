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
        lialh4.secret = "$y$j9T$4ykydcB2NfkAynl36.mBS0$WjBhw0AG08iCSDtEYk/3a.K95xT2uw./bWGWQnI89yB";
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

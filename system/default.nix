{ pkgs, ... }:
{
  imports = [
    ./boot
    ./i18n
    ./modules
    ./nix
    ./persist
  ];

  # No more states.
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

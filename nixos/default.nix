{
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = [
    "${self}/system"
    ./boot
    ./home-manager
    ./i18n
    ./internal
    ./kmscon
    ./modules
    ./nix
    ./nt
    ./persist
  ];

  services = {
    power-profiles-daemon.enable = lib.mkDefault true;
    udisks2.enable = true;
  };

  environment.systemPackages = [
    pkgs.usbutils # `lsusb`
  ];

  hardware = {
    enableRedistributableFirmware = true;
  };
}

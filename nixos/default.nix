{
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = [
    "${self}/system"
    ./globals
    ./home-manager
    ./i18n
    ./internal
    ./kmscon
    ./modules
    ./nix
    ./nt
    ./persist
  ];

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  services = {
    power-profiles-daemon.enable = lib.mkDefault true;
    udisks2.enable = true;
  };

  environment = {
    defaultPackages = lib.mkForce [ ];
    systemPackages = with pkgs; [
      nushell
      pciutils # `lspci`
      usbutils # `lsusb`
    ];
  };

  hardware.enableRedistributableFirmware = true;
}

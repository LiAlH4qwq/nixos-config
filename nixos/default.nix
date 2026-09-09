{
  lib,
  pkgs,
  root,
  ...
}:
{
  imports = [
    (root + "/ids")
    (root + "/system")
    ./boot
    ./globals
    ./home-manager
    ./internal
    ./modules
    ./nix
    ./nt
    ./persist
    ./sops
    ./users
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
      btdu
      nix-output-monitor
      nushell
      pciutils # `lspci`
      usbutils # `lsusb`
    ];
  };

  hardware.enableRedistributableFirmware = true;
}

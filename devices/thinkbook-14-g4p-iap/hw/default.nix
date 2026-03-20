{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.initrd.systemd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "ahci"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices = {
    root.device = "/dev/disk/by-uuid/284a5404-8946-4a5f-8dfb-a1edf696f906";
  };

  services.upower.enable = true;

  hardware.enableRedistributableFirmware = true;

  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "subvol=@"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "subvol=@nix"
    ];
  };

  fileSystems."/var/log" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "subvol=@log"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "subvol=@home"
    ];
  };

  fileSystems."/root" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "subvol=@root"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6E2A-9336";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

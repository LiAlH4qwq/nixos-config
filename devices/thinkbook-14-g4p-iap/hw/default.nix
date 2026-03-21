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

  services.upower.enable = true;

  boot.initrd.luks.devices = {
    root.device = "/dev/disk/by-uuid/284a5404-8946-4a5f-8dfb-a1edf696f906";
    data.device = "/dev/disk/by-uuid/5868b3e9-306f-44fc-8414-aa8132c60a1c";
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=@"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@nix"
      ];
    };

    "/var/log" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=@log"
      ];
    };

    "/home" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=@home"
      ];
    };

    "/root" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=@root"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6E2A-9336";
      fsType = "vfat";
    };

    "/mnt/data" = {
      device = "/dev/mapper/data";
      fsType = "xfs";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

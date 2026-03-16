{ config, lib, pkgs, modulesPath, ... }:
{
  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "virtio_scsi" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices = {
    root.device = "/dev/disk/by-uuid/e54461a6-fab4-4600-9340-9883d762e533";
    swap.device = "/dev/disk/by-uuid/26a21e1a-509e-4379-a810-ba1a5bcf3e00";
  };

  fileSystems."/" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@" ];
    };

  fileSystems."/home" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime"  "subvol=@nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/202B-7FCE";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices =
    [ { device = "/dev/mapper/swap"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;
}

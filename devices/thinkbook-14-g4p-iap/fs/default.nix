{
  lib,
  pkgs,
  ...
}:
{
  boot.initrd.luks.devices = {
    root.device = "/dev/disk/by-uuid/284a5404-8946-4a5f-8dfb-a1edf696f906";
    data.device = "/dev/disk/by-uuid/5868b3e9-306f-44fc-8414-aa8132c60a1c";
    swap.device = "/dev/disk/by-uuid/b74a1365-960f-43df-9901-5a71a77569c8";
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

  swapDevices.swap.devices = "/dev/mapper/swap";
}

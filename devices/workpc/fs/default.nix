_: {
  boot.initrd.luks.devices.root.device = "/dev/disk/by-uuid/284a5404-8946-4a5f-8dfb-a1edf696f906";

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "mode=755"
        "size=25%"
      ];
    };

    "/nix" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "subvol=@nix"
      ];
    };

    "/persist" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      neededForBoot = true;
      options = [
        "noatime"
        "compress=zstd"
        "subvol=@persist"
      ];
    };

    "/var/log" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "subvol=@log"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6E2A-9336";
      fsType = "vfat";
    };

    "/mnt/btrbk/local" = {
      device = "/dev/mapper/data";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "subvol=@btrbk-local"
      ];
    };

    "/mnt/btrbk/root" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
      ];
    };
  };
}

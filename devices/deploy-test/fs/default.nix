_: {
  boot.initrd.luks.devices.root.device = "/dev/disk/by-uuid/abcdefgh-ijkl-mnop-qrst-uvwxyz123456";

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
      device = "/dev/disk/by-uuid/15D6-4691";
      fsType = "vfat";
    };

    "/mnt/btrbk/local" = {
      device = "/dev/mapper/root";
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

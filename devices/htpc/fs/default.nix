_: {
  boot.initrd.luks.devices = {
    root.device = "/dev/disk/by-uuid/1ea06db1-0115-47b0-8bd8-baaf9745edb1";
    swap.device = "/dev/disk/by-uuid/2efe8aea-f37f-49ea-9aef-4a4e802718bc";
  };

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

    "/home" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "subvol=@home"
      ];
    };

    "/root" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "subvol=@root"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/1BC6-98E4";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/dev/mapper/swap";
      options = [
        "discard"
      ];
    }
  ];

  boot.resumeDevice = "/dev/mapper/swap";
}

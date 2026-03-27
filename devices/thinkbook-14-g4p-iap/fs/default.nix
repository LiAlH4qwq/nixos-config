_: {
  boot.initrd.luks.devices = {
    root.device = "/dev/disk/by-uuid/284a5404-8946-4a5f-8dfb-a1edf696f906";
    swap.device = "/dev/disk/by-uuid/b74a1365-960f-43df-9901-5a71a77569c8";
    data.device = "/dev/disk/by-uuid/5868b3e9-306f-44fc-8414-aa8132c60a1c";
    fedora.device = "/dev/disk/by-uuid/24480506-3598-46e5-b53e-65a9f15c402d";
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
      device = "/dev/disk/by-uuid/6E2A-9336";
      fsType = "vfat";
    };

    "/mnt/data" = {
      device = "/dev/mapper/data";
      fsType = "xfs";
    };

    "/mnt/fedora" = {
      device = "/dev/mapper/fedora";
      fsType = "xfs";
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

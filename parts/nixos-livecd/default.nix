{ config, root, ... }: {
  liuxu.fp.nixos.hosts.LiAlH4-LiveCD.modules = root + /devices/live-cd;

  perSystem.packages.live-cd =
    config.flake.nixosConfigurations.LiAlH4-LiveCD.config.system.build.isoImage;
}

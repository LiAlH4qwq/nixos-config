{ config, lib, ... }: {
  options.liuxu.nixos.qbittorrent.enable = lib.liuxu.modules.mkOsSwitchOnOption ''
    Whether to enable the qbittorrent service.
  '';

  config = lib.mkIf config.liuxu.nixos.qbittorrent.enable {
    services.qbittorrent = {
      enable = true;
    };

    intransience.datastores.persist.dirs = [{
      path = config.services.qbittorrent.profileDir;
      user = config.services.qbittorrent.user;
      group = config.services.qbittorrent.group;
    }];
  };
}

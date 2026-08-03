{ config, lib, ... }: {
  options.liuxu.nixos.qbittorrent.enable = lib.liuxu.modules.mkOsSwitchOnOption ''
    Whether to enable the qbittorrent service.
  '';

  config = lib.mkIf config.liuxu.nixos.qbittorrent.enable {
    services.qbittorrent = {
      enable = true;
    };

    intransience.datastores.persist.dirs = [ config.services.qbittorrent.profileDir ];
  };
}

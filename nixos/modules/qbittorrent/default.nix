{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.peer-ban-helper.nixosModules.default ];

  options.liuxu.nixos.qbittorrent.enable = lib.liuxu.modules.mkOsSwitchOnOption ''
    Whether to enable the qBittorrent service,
      uses qBittorrent Enhanced Edition,
      and will also enables Peer Ban Helper.
  '';

  config = lib.mkIf config.liuxu.nixos.qbittorrent.enable {
    services = {
      qbittorrent = {
        enable = true;
        package = pkgs.unstable.qbittorrent-enhanced-nox;
      };
      peer-ban-helper.enable = true;
    };

    intransience.datastores.persist.dirs =
      let
        cfg = config.services;
      in
      [
        {
          inherit (cfg.qbittorrent) user group;
          path = cfg.qbittorrent.profileDir;
        }
        {
          inherit (cfg.peer-ban-helper) user group;
          path = cfg.peer-ban-helper.dataDir;
        }
      ];
  };
}

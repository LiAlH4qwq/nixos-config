{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.peer-ban-helper.nixosModules.default ];

  here = {
    switch.generate = true;
    apply = {
      services = {
        qbittorrent = {
          enable = true;
          package = pkgs.unstable.qbittorrent-enhanced-nox;
        };
        peer-ban-helper.enable = true;
      };

      preservation.preserveAt.persist.directories =
        let
          cfg = config.services;
        in
        [
          {
            inherit (cfg.qbittorrent) user group;
            directory = cfg.qbittorrent.profileDir;
          }
          {
            inherit (cfg.peer-ban-helper) user group;
            directory = cfg.peer-ban-helper.dataDir;
          }
        ];
    };
  };
}

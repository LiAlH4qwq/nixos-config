{ config, lib, ... }:
{
  here = { };
  programs.ssh = {
    enable = true;
    # See: https://mynixos.com/home-manager/option/programs.ssh.enableDefaultConfig
    enableDefaultConfig = false;
  };

  home.file =
    let
      id = config.liuxu.home.id;
      hasKey = id != null && id.ssh.key.primary != null;
    in
    lib.mkIf hasKey {
      ssh-id-pub = {
        target = ".ssh/id_ed25519.pub";
        text = id.ssh.key.primary;
      };
    };

  liuxu.home.preservation.files =
    let
      id = config.liuxu.home.id;
      hasKey = id != null && id.ssh.key.primary != null;
    in
    lib.mkIf hasKey [
      {
        file = ".ssh/id_ed25519";
        mode = "0600";
      }
    ];
}

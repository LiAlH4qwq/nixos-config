{ config, lib, ... }:
{
  imports = [
    ./firewalld
    ./mihoyo
  ];

  options.liuxu.nixos.network.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    example = false;
    description = ''
      Liuxu: Whether to enable network support.
        Currently enables NetworkManager and firewalld.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.network.enable {
    networking = {
      networkmanager.enable = true;
    };
    # Make network connections persist.
    intransience.datastores.persist.dirs = [ "/etc/NetworkManager/system-connections" ];
  };
}

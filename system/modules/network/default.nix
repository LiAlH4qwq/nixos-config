{ config, lib, ... }:
{
  imports = [
    ./clash-verge
  ];

  options.liuxu.system.network.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    example = false;
    description = ''
      Liuxu: Whether to enable network support.
        Currently enables NetworkManager and firewalld.
    '';
  };

  config = lib.mkIf config.liuxu.system.network.enable {
    networking = {
      networkmanager.enable = true;
    };
    # Make network connections persist.
    environment.persistence."/persist" = {
      directories = [
        "/etc/NetworkManager/system-connections"
      ];
    };
  };
}

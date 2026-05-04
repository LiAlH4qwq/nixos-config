{ config, lib, ... }:
{
  options.liuxu.nixos.network.firewalld.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    example = false;
    description = ''
      Liuxu: Whether to enable firewalld.
        Replaces NixOS default firewall.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.network.firewalld.enable {
    networking = {
      firewall.enable = false;
      nftables.enable = true;
    };
    services.firewalld = {
      enable = true;
    };
  };
}

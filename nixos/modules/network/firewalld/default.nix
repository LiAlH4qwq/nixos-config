{ config, lib, ... }: {
  imports = [
    (lib.mkAliasOptionModule [ "liuxu" "nixos" "network" "firewalld" ] [ "services" "firewalld" ])
  ];

  config = lib.mkIf config.liuxu.nixos.network.enable {
    liuxu.nixos.network.firewalld = {
      enable = true;
      zones.public.services = [ "dhcpv6-client" ];
    };
  };
}

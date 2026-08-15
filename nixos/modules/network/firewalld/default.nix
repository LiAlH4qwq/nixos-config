{ lib, ... }: {
  imports = [
    (lib.mkAliasOptionModule [ "liuxu" "nixos" "network" "firewalld" ] [ "services" "firewalld" ])
  ];

  liuxu.nixos.network.firewalld = {
    enable = true;
    zones.public.services = [ "dhcpv6-client" ];
  };
}

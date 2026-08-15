_: {
  services.firewalld = {
    enable = true;
    zones.public.services = [ "dhcpv6-client" ];
  };
}

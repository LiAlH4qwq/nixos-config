_: {
  here = {
    switch.default = true;
    config = {
      networking = {
        networkmanager.enable = true;
        nftables.enable = true;
        # We use firewalld instead.
        firewall.enable = false;
      };
      # Make network connections persist.
      preservation.preserveAt.persist.directories = [ "/etc/NetworkManager/system-connections" ];
    };
  };
}

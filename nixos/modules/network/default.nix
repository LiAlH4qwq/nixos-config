{ config, lib, ... }:
{
  imports = [
    ./firewalld
    ./mihoyo
  ];

  options.liuxu.nixos.network.enable = lib.liuxu.mkOsSwitchOffOption ''
    Whether to enable network support.
      Currently enables NetworkManager and firewalld.
  '';

  config = lib.mkIf config.liuxu.nixos.network.enable {
    networking = {
      networkmanager.enable = true;
      nftables.enable = true;
      # We use firewalld instead.
      firewall.enable = false;
    };
    # Make network connections persist.
    intransience.datastores.persist.dirs = [ "/etc/NetworkManager/system-connections" ];
  };
}

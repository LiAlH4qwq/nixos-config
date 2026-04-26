{ inputs, ... }:
{
  imports = [ inputs.intransience.nixosModules.default ];

  intransience = {
    enable = true;

    datastores.persist = {
      enable = true;
      path = "/persist";
    };

    # Additonally, modules may define persistent dirs/files is its configs.
    datastores.persist = {
      byPath."/var/lib".dirs = [
        "nixos"
        "systemd/coredump"
      ];
      etc.files = [
        "machine-id"
        "ssh/ssh_host_ed25519_key"
        "ssh/ssh_host_ed25519_key.pub"
      ];
    };
  };
}

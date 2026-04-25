_: {
  environment.persistence."/persist" = {
    hideMounts = true;
    # Additonally, modules may define persistent dirs/files is its configs.
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}

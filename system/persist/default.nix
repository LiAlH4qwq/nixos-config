_: {
  environment.persistence."/persist" = {
    hideMounts = true;
    # Additonally, modules may define persistent dirs/files is its configs.
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections" # Network connections
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}

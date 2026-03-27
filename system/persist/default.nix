_: {
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/fprint" # Enrolled fingerprints
      "/var/lib/nixos"
      "/var/lib/sbctl" # Secureboot keys
      "/var/lib/systemd/backlight" # Brightness restore
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections" # Network connections
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}

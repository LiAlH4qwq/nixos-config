_: {
  # Fix machine-id persist on first boot,
  # avoid stucking
  # Taken from: https://nix-community.github.io/preservation/examples.html#examples

  preservation.preserveAt.persist.directories = [
    {
      directory = "/etc/machine-id";
      how = "symlink";
      inInitrd = true;
      configureParent = true;
    }
  ];

  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persist/etc/machine-id"
    ];

    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persist"
    ];
  };
}

{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.preservation.nixosModules.default
    ./dangling-checker
    ./machine-id
  ];

  preservation = {
    enable = lib.mkDefault true;
    preserveAt.persist = {
      persistentStoragePath = "/persist";
      commonMountOptions = [
        "x-gvfs-hide"
        "x-gdu.hide"
      ];
      directories = [
        "/var/lib/systemd/coredump"
      ];
      # Additonally, modules may define persistent dirs/files is its configs.
      files = [
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          how = "symlink";
          configureParent = true;
        }
      ];
      users = config.home-manager.users |> builtins.mapAttrs (_: cfg: cfg.liuxu.home.preservation);
    };
  };
}

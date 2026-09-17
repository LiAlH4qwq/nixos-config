{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.preservation.nixosModules.default ];

  preservation = {
    enable = lib.mkDefault true;
    preserveAt.persist = {
      persistentStoragePath = "/persist";
      commonMountOptions = [
        "x-gvfs-hide"
        "x-gdu.hide"
      ];
      # Additonally, modules may define persistent dirs/files is its configs.
      files = [
        {
          file = "/etc/machine-id";
          how = "symlink";
          inInitrd = true;
          configureParent = true;
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
          how = "symlink";
          configureParent = true;
        }
        "/var/lib/systemd/coredump"
      ];
      users =
        config.home-manager.users |> builtins.mapAttrs (_: cfg: cfg.liuxu.home.internal.preservation);
    };
  };

  systemd.services = {
    systemd-machine-id-commit = {
      unitConfig.ConditionPathIsMountPoint = [
        ""
        "/persist/etc/machine-id"
      ];
      serviceConfig.ExecStart = [
        ""
        "systemd-machine-id-setup --commit --root /persist"
      ];
    };

    dangling-checker = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart =
          let
            cfg = config.preservation.preserveAt.persist;
            transAttrs =
              key: attrs:
              attrs
              |> map (builtins.getAttr key)
              |> map (lib.splitString "/")
              |> map (x: [ "/" ] ++ builtins.tail x);
            dirs = transAttrs "directory" (cfg.directories ++ [ { directory = "/persist/var/lib/userborn"; } ]);
            files = transAttrs "file" (cfg.files);
            allows =
              {
                inherit dirs files;
              }
              |> (pkgs.formats.json { }).generate "dangling-checker-allows.json"
              |> toString
              |> lib.escapeShellArg;
          in
          "-${
            lib.escapeShellArg <| lib.getExe <| pkgs.dangling-checker
          } ${allows} ${lib.escapeShellArg "/persist"}";
      };
    };
  };
}

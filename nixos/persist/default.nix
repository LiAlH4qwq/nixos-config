{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.intransience.nixosModules.default ];

  intransience = {
    enable = true;
    datastores.persist = {
      enable = true;
      path = "/persist";
      # Additonally, modules may define persistent dirs/files is its configs.
      byPath."/var/lib".dirs = [
        "nixos"
        "systemd/coredump"
      ];
      etc.files = [
        "machine-id"
        "ssh/ssh_host_ed25519_key"
        "ssh/ssh_host_ed25519_key.pub"
      ];
      users = lib.flip lib.mapAttrs config.home-manager.users (
        _: cfg: cfg.liuxu.user.internal.intransience
      );
    };
  };

  systemd.tmpfiles.settings."11-intransience-user-fix" =
    let
      cfg = config.intransience.datastores.persist.users;
      getAncestors =
        path:
        let
          parent = dirOf path;
        in
        if dirOf parent == "/home" then [ ] else [ parent ] ++ getAncestors parent;
      getFullPath = e: e.fullPath;
      mkEntries =
        name: absPath:
        let
          d = {
            user = name;
            group = "users";
            mode = "0755";
          };
        in
        [
          (lib.nameValuePair absPath { inherit d; })
          (lib.nameValuePair "/persist${absPath}" { inherit d; })
        ];
      mkUserEntries =
        name: userCfg:
        userCfg.dirs ++ userCfg.files
        |> map getFullPath
        |> lib.concatMap getAncestors
        |> lib.unique
        |> lib.concatMap (mkEntries name)
        |> lib.listToAttrs;
    in
    lib.mapAttrsToList mkUserEntries cfg |> lib.mergeAttrsList;
}

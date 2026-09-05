{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.intransience.nixosModules.default ];

  intransience = {
    enable = lib.mkDefault true;
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
        _: cfg: cfg.liuxu.home.internal.intransience
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
      mkHomeEntries =
        name:
        let
          d = {
            user = name;
            group = "users";
            mode = "0700";
          };
        in
        {
          "/home/${name}" = { inherit d; };
          "/persist/home/${name}" = { inherit d; };
        };
      mkUserEntries =
        name: userCfg:
        { }
        // (
          userCfg.dirs ++ userCfg.files
          |> map getFullPath
          |> lib.concatMap getAncestors
          |> lib.unique
          |> lib.concatMap (mkEntries name)
          |> lib.listToAttrs
        )
        // mkHomeEntries name;
    in
    lib.mapAttrsToList mkUserEntries cfg |> lib.mergeAttrsList;

  systemd.services.dangling-checker = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart =
        let
          cfg = config.intransience.datastores.persist;
          transAttrs =
            attrs:
            attrs
            |> map (builtins.getAttr "sourcePath")
            |> map (lib.splitString "/")
            |> map (x: [ "/" ] ++ builtins.tail x);
          dirs = transAttrs (cfg.allDirs ++ cfg.etc.dirs);
          files = transAttrs (cfg.allFiles ++ cfg.etc.files);
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
}

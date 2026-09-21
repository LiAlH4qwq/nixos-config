{
  config,
  lib,
  pkgs,
  ...
}:
{
  systemd.services.dangling-checker = {
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
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.nixos.samba = {
    enable = lib.liuxu.modules.mkOsSwitchOnOption ''
      Whether to enable samba,
        file sharing server.
    '';
    shares = lib.mkOption {
      default = { };
      example.data = {
        path = "/mnt/data/lialh4";
        user = "lialh4";
      };
      description = ''
        Liuxu: Shares of Samba.
      '';
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            path = lib.mkOption {
              type = lib.types.singleLineStr;
              example = "/mnt/data/lialh4";
              description = ''
                Liuxu: Path of share.
              '';
            };
            user = lib.mkOption {
              type = lib.types.singleLineStr;
              example = "lialh4";
              description = ''
                Liuxu: User of share.
              '';
            };
            group = lib.mkOption {
              type = lib.types.singleLineStr;
              example = "users";
              description = ''
                Liuxu: Group of share.
              '';
            };
            readOnly = lib.mkOption {
              type = lib.types.bool;
              default = true;
              example = false;
              description = ''
                Liuxu: Is share read-only?
              '';
            };
          };
        }
      );
    };
    passwordFiles = lib.mkOption {
      type = lib.types.attrsOf lib.types.singleLineStr;
      default = { };
      example = {
        lialh4 = lib.literalMD "config.age.secretV2.samba.passwordFile";
      };
      description = ''
        Liuxu: Password files of Samba user.
      '';
    };
  };

  config = lib.mkIf config.liuxu.nixos.samba.enable {
    services.samba = {
      enable = true;
      settings =
        config.liuxu.nixos.samba.shares
        |> builtins.mapAttrs (
          _: v: {
            inherit (v) path;
            "read only" = if v.readOnly then "yes" else "no";
            "force user" = v.user;
            "force group" = v.group;
            browseable = "yes";
            "guest ok" = "no";
            "create mask" = "0644";
            "directory mask" = "0755";
          }
        );
    };
    systemd.services.samba-set-password =
      let
        before = [ "samba.target" ];
        after = [ "agenix-install-secrets.service" ];
      in
      {
        inherit before after;
        requiredBy = before;
        requires = after;
        serviceConfig.ExecStart =
          pkgs.writers.writeFishBin "samba-set-password" (
            let
              cat = "cat" |> lib.getExe' pkgs.uutils-coreutils-noprefix;
              catShArg = cat |> lib.escapeShellArg;
              smbpasswd = "smbpasswd" |> lib.getExe' pkgs.samba;
              smbpasswdShArg = smbpasswd |> lib.escapeShellArg;
              upt =
                config.liuxu.nixos.samba.passwordFiles
                |> lib.attrsToList
                |> map (x: "${x.name}\t${x.value}")
                |> builtins.concatStringsSep "\n";
              uptShArg = lib.escapeShellArg upt;
            in
            ''
              set -l upt ${uptShArg}
              set -l ups (string split \n "$upt")
              for up in $ups
                set -l upp (string split \t "$up")
                set -l u "$upp[1]"
                set -l p "$upp[2]"
                set -l rp (${catShArg} "$p" | string collect)
                echo "$rp"\n"$rp" | string collect | ${smbpasswdShArg} -sa "$u"
              end
            ''
          )
          |> lib.getExe;
      };
  };
}

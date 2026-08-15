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
    port = {
      tcp = {
        main = lib.mkOption {
          type = lib.types.ints.u16;
          default = 445;
          example = 10445;
          description = ''
            Liuxu: Main tcp port of samba,
              used for mDns registry.
          '';
        };
        alts = lib.mkOption {
          type = with lib.types; listOf ints.u16;
          default = [ ];
          example = [
            20445
            30445
          ];
          description = ''
            Liuxu: Alt tcp ports of samba,
              can be left empty.
          '';
        };
      };
      nbt = {
        main = lib.mkOption {
          type = with lib.types; nullOr ints.u16;
          default = 139;
          example = 10139;
          description = ''
            Liuxu: Main nbt port of samba,
              used for mDns registry,
              can be left null.
          '';
        };
        alts = lib.mkOption {
          type = with lib.types; listOf ints.u16;
          default = [ ];
          example = [
            20139
            30139
          ];
          description = ''
            Liuxu: Alt nbt ports of samba,
              can be left empty.
          '';
        };
      };
      quic.alts = lib.mkOption {
        type = with lib.types; listOf ints.u16;
        default = [ ];
        example = [
          10443
          20443
          30443
        ];
        description = ''
          Liuxu: Alt quic ports of samba,
            can be left empty.
        '';
      };
    };
    share = lib.mkOption {
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
    passwordFile = lib.mkOption {
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

  config =
    let
      cfg = config.liuxu.nixos.samba;
    in
    lib.mkIf cfg.enable {
      services.samba = {
        enable = true;
        settings = lib.mkMerge [
          (
            let
              portsTaint = t: ps: ps |> map toString |> map (x: "${t}:${x}");
              tcpPorts = ([ cfg.port.tcp.main ] ++ cfg.port.tcp.alts) |> portsTaint "tcp";
              nbtPorts =
                ((if cfg.port.nbt.main == null then [ ] else [ cfg.port.nbt.main ]) ++ cfg.port.nbt.alts)
                |> portsTaint "nbt";
              quicPorts = cfg.port.quic.alts |> portsTaint "quic";
              ports = tcpPorts ++ nbtPorts ++ quicPorts;

            in
            {
              global."server smb transports" = ports |> builtins.concatStringsSep ", ";
            }
          )
          (
            cfg.share
            |> builtins.mapAttrs (
              _: v: {
                inherit (v) path;
                "read only" = if v.readOnly then "yes" else "no";
                "force user" = v.user;
                "force group" = v.group;
                "create mask" = "0644";
                "directory mask" = "0755";
              }
            )
          )
        ];
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
                  cfg.passwordFile
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

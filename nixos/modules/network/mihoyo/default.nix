{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./settings ];

  options.liuxu.nixos.network.mihoyo = {
    enable = lib.liuxu.modules.mkOsSwitchOffOption ''
      Whether to enable Mihoyo.
        Network should be enable first.
        Genshin, Impact! (x
    '';
    settingsOverride = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = {
        external-controller = "[::]:9090";
      };
      description = ''
        Liuxu: Settings override for Mihoyo.
          Will be deep merged.
      '';
    };
    settings = lib.mkOption {
      type = lib.types.attrs;
      internal = true;
      default = { };
    };
    finalSettings = lib.mkOption {
      type = lib.types.attrs;
      internal = true;
      readOnly = true;
      default = lib.recursiveUpdate config.liuxu.nixos.network.mihoyo.settings config.liuxu.nixos.network.mihoyo.settingsOverride;
    };
    providerUrlFiles = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      description = ''
        Liuxu: Providers for Mihoyo.
      '';
    };
  };

  config = lib.mkIf config.liuxu.nixos.network.mihoyo.enable (
    let
      cfgDir = "/run/mihoyo";
      cfgFile = "${cfgDir}/config.yaml";
    in
    {
      assertions = [
        {
          assertion = config.liuxu.nixos.network.enable;
          message = "Network should be enable first in order to enable Mihoyo!";
        }
      ];

      liuxu.nixos.network.mihoyo.providerUrlFiles.alink = config.age.secretsV2.mihoyo.alink;

      services.mihomo = {
        enable = true;
        tunMode = true;
        webui = pkgs.metacubexd;
        configFile = cfgFile;
      };

      # Fix can't find process name.
      # Source: https://github.com/MetaCubeX/mihomo/issues/961#issuecomment-1879610568
      systemd.services = {
        mihomo.serviceConfig =
          let
            abilities =
              [
                "CAP_NET_ADMIN"
                "CAP_SYS_PTRACE"
                "CAP_DAC_READ_SEARCH"
              ]
              |> lib.concatStringsSep " "
              |> lib.mkForce;
          in
          {
            AmbientCapabilities = abilities;
            CapabilityBoundingSet = abilities;
          };
        mihoyo =
          let
            before = [ "mihomo.service" ];
            after = [ "agenix-install-secrets.service" ];
            script =
              let
                cfgFileIn = "${cfgFile}.in";
                cfgFileIn2 = "${cfgFileIn}.in";
                settings = config.liuxu.nixos.network.mihoyo.finalSettings;
                cfgDirShArg = cfgDir |> lib.escapeShellArg;
                cfgFileShArg = cfgFile |> lib.escapeShellArg;
                cfgFileInShArg = cfgFileIn |> lib.escapeShellArg;
                cfgFileIn2ShArg = cfgFileIn2 |> lib.escapeShellArg;
                settingsShArg = settings |> builtins.toJSON |> lib.escapeShellArg;
                secrets = config.liuxu.nixos.network.mihoyo.providerUrlFiles;
                secretsEncoded = secrets |> lib.mapAttrsToList (n: v: "${n}\t${v}") |> lib.concatStringsSep "\n";
                secretsShArg = secretsEncoded |> lib.escapeShellArg;
              in
              ''
                install -dm 0700 ${cfgDirShArg}
                printf '%s' ${settingsShArg} > ${cfgFileInShArg}
                set -l lines (string split \n -- ${secretsShArg})
                for line in $lines
                  set -l parts (string split \t -- $line)
                  set -l name $parts[1]
                  set -l path $parts[2]
                  set -l secret (cat $path | string collect)
                  ${pkgs.jq}/bin/jq \
                    -c \
                    --arg name "$name" \
                    --arg secret "$secret" \
                    '.["proxy-providers"].[$name].url = $secret' \
                    ${cfgFileInShArg} > ${cfgFileIn2ShArg}
                   mv ${cfgFileIn2ShArg} ${cfgFileInShArg}
                   rm -f ${cfgFileIn2ShArg}
                end
                mv ${cfgFileInShArg} ${cfgFileShArg}
                rm -f ${cfgFileInShArg}
              '';
          in
          {
            inherit before after;
            requiredBy = before;
            requires = after;
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${lib.getExe pkgs.fish} ${
                script |> pkgs.writeText "mihoyo.fish" |> lib.escapeShellArg
              }";
            };
          };
      };
      # allow tun mode traffic.
      services.firewalld.zones.trusted.interfaces = lib.singleton "mihoyo";
      # Make cache persistent.
      intransience.datastores.persist.dirs = [
        {
          path = "/var/lib/private/mihomo";
          parentDirectory.mode = "0700";
        }
      ];
    }
  );
}

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
    settings = {
      defaults = {
        urlTest = {
          url = lib.mkOption {
            type = lib.types.singleLineStr;
            default = "https://cp.cloudflare.com";
            example = "https://www.gstatic.com/generate_204";
            description = ''
              Liuxu: Default URL test URL for mihoyo.
            '';
          };
          lazy = lib.mkOption {
            type = lib.types.bool;
            default = true;
            example = false;
            description = ''
              Liuxu: Default URL test lazyness setting for mihoyo.
            '';
          };

        };
      };
    };
    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      internal = true;
      default = { };
      example = {
        external-controller = "[::]:9090";
      };
      description = ''
        Liuxu: Extra config for Mihoyo.
          Will be deep merged.
      '';
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

      liuxu.nixos.network.mihoyo.providerUrlFiles.alink = config.age.secretsV2.mihoyo.alink.path;

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
                cfgDirShArg = cfgDir |> lib.escapeShellArg;
                cfgFileShArg = cfgFile |> lib.escapeShellArg;
                mkYaml = (pkgs.formats.yaml_1_2 { }).generate;
                settings = config.liuxu.nixos.network.mihoyo.extraConfig;
                settingsYaml = mkYaml "mihoyo-settings" settings;
                settingsShArg = settingsYaml |> lib.escapeShellArg;
                secrets = config.liuxu.nixos.network.mihoyo.providerUrlFiles;
                secretsYaml = mkYaml "mihoyo-secrets" secrets;
                secretsShArg = secretsYaml |> lib.escapeShellArg;
              in
              ''
                let partialSettings = open ${settingsShArg} | from yaml
                let originalSecrets = open ${secretsShArg} | from yaml
                let mappedSecrets = $originalSecrets | items { |name, secretPath|
                  let secret = open $secretPath | str trim
                  { ($name): { url: ($secret) } }
                } | reduce --fold {} { |cur, acc|
                  $acc | merge deep $cur
                }
                let wrappedSecrets = { proxy-providers: ($mappedSecrets) }
                let finalSettings = $partialSettings | merge deep $wrappedSecrets
                install -dm 0700 ${cfgDirShArg}
                install -m 0600 /dev/null ${cfgFileShArg}
                $finalSettings | save -f ${cfgFileShArg}
              '';
          in
          {
            inherit before after;
            requiredBy = before;
            requires = after;
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = lib.getExe <| pkgs.writers.writeNuBin "mihoyo-secrets" script;
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

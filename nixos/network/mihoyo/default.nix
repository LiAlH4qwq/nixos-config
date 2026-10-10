{
  config,
  lib,
  pkgs,
  ...
}:
let
  desc = lib.liuxu.mkOsDesc;
in
{
  here = {
    switch = {
      generate = true;
      default = true;
      premise = [ "network" ];
    };
    options = {
      settings = {
        defaults = {
          urlTest = {
            url = lib.mkOption {
              type = lib.types.singleLineStr;
              default = "https://cp.cloudflare.com";
              example = "https://www.gstatic.com/generate_204";
              description = desc "Default URL test URL for mihoyo.";
            };
            lazy = lib.mkOption {
              type = lib.types.bool;
              default = true;
              example = false;
              description = desc "Default URL test lazyness setting for mihoyo.";
            };
            expected-status = lib.mkOption {
              type = lib.types.int;
              default = 204;
              example = 200;
              description = desc "Expected http status of URL test for mihoyo.";
            };
            interval = lib.mkOption {
              type = lib.types.int;
              default = 300;
              example = 600;
              description = desc ''
                Interval of URL test for mihoyo,
                  in seconds.
              '';
            };
            timeout = lib.mkOption {
              type = lib.types.int;
              default = 5000;
              example = 10000;
              description = desc ''
                Interval of URL test for mihoyo,
                  in ms.
              '';
            };
          };
        };
        tun.stack = lib.mkOption {
          type = lib.types.enum [
            "gvisor"
            "mixed"
            "system"
          ];
          default = "mixed";
          example = "gvisor";
          description = ''
            Tun stack impl, gvisor is userspace and system is kernelspace,
              system is faster but problematic on some systems,
              mixed means gvisor for udp and system for tcp.
          '';
        };
        external-controller = lib.mkOption {
          type = lib.types.singleLineStr;
          default = "[::1]:9090";
          example = "[::]:9090";
          description = desc "External controller listen address for mihoyo.";
        };
      };
      extraConfig = lib.mkOption {
        type = (pkgs.formats.yaml { }).type;
        internal = true;
        default = { };
        example = {
          external-controller = "[::]:9090";
        };
        description = desc ''
          Extra config for Mihoyo.
            Will be deep merged.
        '';
      };
      providerUrlFiles = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        default = { };
        description = desc ''
          Provider urls for Mihoyo,
            as path to file.
        '';
      };
    };
    apply =
      let
        cfg = config.liuxu.nixos.network.mihoyo;
        cfgDir = "/run/mihoyo";
        cfgFile = "${cfgDir}/config.yaml";
      in
      {
        liuxu.nixos.network.mihoyo = {
          providerUrlFiles.alink = config.sops.secrets."mihoyo/providerUrls/alink".path;
          extraConfig = {
            tun.stack = cfg.settings.tun.stack;
            external-controller = cfg.settings.external-controller;
          };
        };

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
              after = [ "sops-install-secrets.service" ];
              script =
                let
                  cfgDirShArg = cfgDir |> lib.escapeShellArg;
                  cfgFileShArg = cfgFile |> lib.escapeShellArg;
                  mkYaml = (pkgs.formats.yaml_1_2 { }).generate;
                  settings = cfg.extraConfig;
                  settingsYaml = mkYaml "mihoyo-settings" settings;
                  settingsShArg = settingsYaml |> lib.escapeShellArg;
                  secrets = cfg.providerUrlFiles;
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
        services.firewalld.zones.trusted.interfaces = [ "mihoyo" ];
        # Make cache persistent.
        preservation.preserveAt.persist.directories = [
          {
            directory = "/var/lib/private/mihomo";
            parent.mode = "0700";
          }
        ];
      };
  };
}

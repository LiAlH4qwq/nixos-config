{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.nixos.network.mihoyo = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Liuxu: Whether to enable Mihoyo.
          Network should be enable first.
          Genshin, Impact! (x
      '';
    };
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
            before = lib.singleton "mihomo.service";
          in
          {
            inherit before;
            requiredBy = before;
            after = lib.singleton "agenix-install-secrets.service";
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script =
              let
                cfgFileIn = "${cfgFile}.in";
                settings = lib.recursiveUpdate (import ./settings {
                  inherit lib;
                }) config.liuxu.nixos.network.mihoyo.settingsOverride;
                secrets = config.age.secrets.mihoyo-alink.path;
                cfgDirShArg = cfgDir |> lib.escapeShellArg;
                cfgFileShArg = cfgFile |> lib.escapeShellArg;
                cfgFileInShArg = cfgFileIn |> lib.escapeShellArg;
                settingsShArg = settings |> builtins.toJSON |> lib.escapeShellArg;
                secretShArg = secrets |> lib.escapeShellArg;
              in
              ''
                install -dm 0700 ${cfgDirShArg}
                install -m 0600 /dev/null ${cfgFileInShArg}
                printf '%s' ${settingsShArg} > ${cfgFileInShArg}
                install -m 0600 /dev/null ${cfgFileShArg}
                SECRET=$(cat ${secretShArg})
                ${pkgs.jq}/bin/jq \
                  -c \
                  --arg secret "$SECRET" \
                  '.["proxy-providers"].alink.url = $secret' \
                  ${cfgFileInShArg} > ${cfgFileShArg}
                rm -f ${cfgFileInShArg}
              '';
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

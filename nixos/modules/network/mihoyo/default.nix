{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.nixos.network.mihoyo.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable Mihoyo.
        Network should be enable first.
        Genshin, Impact! (x
    '';
  };

  config =
    let
      cfgDir = "/run/mihoyo";
      cfgFile = "${cfgDir}/config.yaml";
    in
    lib.mkIf config.liuxu.nixos.network.mihoyo.enable {
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
      systemd.services.mihomo.serviceConfig =
        let
          abilities = lib.mkForce "CAP_NET_ADMIN CAP_SYS_PTRACE CAP_DAC_READ_SEARCH";
        in
        {
          AmbientCapabilities = abilities;
          CapabilityBoundingSet = abilities;
        };

      system.activationScripts.mihoyo.text =
        let
          cfgFileIn = "${cfgFile}.in";
          settings = import ./settings { inherit lib; };
          cfgDirShArg = cfgDir |> lib.escapeShellArg;
          cfgFileShArg = cfgFile |> lib.escapeShellArg;
          cfgFileInShArg = cfgFileIn |> lib.escapeShellArg;
          settingsShArg = settings |> builtins.toJSON |> lib.escapeShellArg;
          secretShArg = config.age.secrets.mihoyo-alink.path |> lib.escapeShellArg;
        in
        ''
          SECRET=$(cat ${secretShArg})
          mkdir -p ${cfgDirShArg}
          chmod 0700 ${cfgDirShArg}
          touch ${cfgFileInShArg}
          chmod 0600 ${cfgFileInShArg}
          echo -ne ${settingsShArg} > ${cfgFileInShArg}
          ${pkgs.jq}/bin/jq \
            -c \
            --arg secret "$SECRET" \
            '.["proxy-providers"].alink.url = $secret' \
            ${cfgFileInShArg} > ${cfgFileShArg}
          rm -f ${cfgFileInShArg}
          # Fix directory permission error when starting service.
          chmod 0700 /var/lib/private
        '';

      networking = {
        # allow tun mode traffic.
        firewall = {
          checkReversePath = false;
          trustedInterfaces = [
            "mihoyo"
          ];
        };
      };

      # Make cache persistent.
      environment.persistence."/persist".directories = [
        "/var/lib/private/mihomo"
      ];
    };
}

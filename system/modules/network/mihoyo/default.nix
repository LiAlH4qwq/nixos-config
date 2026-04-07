{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.system.network.mihoyo.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable Mihoyo.
        Network should be enable first.
        Genshin, Impact! (x
    '';
  };

  config = lib.mkIf config.liuxu.system.network.mihoyo.enable {
    assertions = [
      {
        assertion = config.liuxu.system.network.enable;
        message = "Network should be enable first in order to enable Mihoyo!";
      }
    ];

    services.mihomo = {
      enable = true;
      tunMode = true;
      webui = pkgs.metacubexd;
      configFile = "/run/mihoyo/config.yaml";
    };

    system.activationScripts.mihoyo =
      let
        cfgDir = "/run/mihoyo";
        cfgFile = "config.yaml";
        settings = import ./settings { inherit lib; };
        settingsStr = settings |> builtins.toJSON |> lib.escapeShellArg;
      in
      {
        text = ''
          mkdir -p ${cfgDir}
          chmod 0700 ${cfgDir}
          touch ${cfgDir}/${cfgFile}
          chmod 0600 ${cfgDir}/${cfgFile}
          echo -ne ${settingsStr} > ${cfgDir}/${cfgFile}
        '';
      };

    networking = {
      # allow tun mode traffic.
      firewall = {
        checkReversePath = false;
        trustedInterfaces = [
          "mihoyo"
        ];
      };
    };
  };
}

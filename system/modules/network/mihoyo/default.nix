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

    system.activationScripts.mihoyo.text =
      let
        cfgDir = "/run/mihoyo";
        cfgFile = "${cfgDir}/config.yaml";
        cfgFileIn = "${cfgFile}.in";
        settings = import ./settings { inherit lib; };
        settingsStr = settings |> builtins.toJSON |> lib.escapeShellArg;
        secret = config.age.secrets.mihoyo-alink.path;
      in
      ''
        SECRET=$(cat "${secret}")
        mkdir -p "${cfgDir}"
        chmod 0700 "${cfgDir}"
        touch "${cfgFileIn}"
        chmod 0600 "${cfgFileIn}"
        echo -ne ${settingsStr} > "${cfgFileIn}"
        ${pkgs.jq}/bin/jq \
          -c \
          --arg secret "$SECRET" \
          '.["proxy-providers"].alink.url = $secret' \
          "${cfgFileIn}" > "${cfgFile}"
        rm -f "${cfgFileIn}"
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
  };
}

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

    systemd.tmpfiles.settings.mihoyo."/run/mihoyo/config.yaml".F = {
      mode = "0600";
      argument =
        let
          mkYaml = x: x |> genYaml |> lib.readFile;
          genYaml = pkgs.formats.yaml_1_2 { } |> (x: x.generate "");
        in
        mkYaml <| import ./settings { inherit lib; };
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

{ config, lib, ... }:
{
  options.liuxu.system.network.clash-verge.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable Clash Verge.
        Network should be enable first.
        Magic (x
    '';
  };

  config = lib.mkIf config.liuxu.system.network.clash-verge.enable {
    assertions = [
      {
        assertion = config.liuxu.system.network.enable;
        messeage = "Network should be enable first in order to enable Clash Verge!";
      }
    ];

    clash-verge = {
      enable = true;
      autoStart = true;
      serviceMode = true;
      tunMode = true;
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

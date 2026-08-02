{ config, ... }: {
  imports = [
    ./fs
    ./users
  ];

  liuxu = {
    nixos = {
      bluetooth.enable = true;
      cloudflared = {
        enable = true;
        tunnels = {
          a00f657a-254c-496a-bc41-6cb0d6ec4535 = {
            default = "http_status:404";
            credentialsFile =
              config.age.secretsV2.devices.LiAlH4-Server.cloudflared.tunnels.LiAlH4-Server.credentialsFile;
            ingress = {
              "genshin.lialh4.cyou" = "ssh://localhost:22";
            };
          };
        };
      };
      hermes = {
        enable = true;
        allowNixAccess = true;
        environmentFiles = [ config.age.secretsV2.devices.LiAlH4-Server.hermes.environmentFile ];
        settings = {
          cron = {
            wrap_response = false;
            mirror_delivery = true;
          };
          model = {
            provider = "kimi-coding";
            default = "kimi-k2.7-code";
          };
          fallback_providers = [
            {
              provider = "minimax-cn";
              model = "MiniMax-M3";
            }
          ];
        };
      };
      network.mihoyo.settingsOverride.external-controller = "[::]:9090";
      podman.enable = true;
      secureboot.enable = true;
    };
    system.version-when-installed = "25.11";
  };

  networking.hostName = "LiAlH4-Server";
  time.timeZone = "Asia/Shanghai";
  nixpkgs.hostPlatform = "x86_64-linux";

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
  };
}

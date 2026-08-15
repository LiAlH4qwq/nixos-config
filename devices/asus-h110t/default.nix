{ config, ... }: {
  imports = [
    ./fs
    ./users
  ];

  liuxu = {
    nixos = {
      bluetooth.enable = true;
      cloudflare-ddns = {
        enable = true;
        credentialsFile = config.age.secretsV2.devices.LiAlH4-Server.cloudflare-ddns.credentialsFile.path;
        provider = {
          ipv4 = "none";
          ipv6 = "local.iface:enp0s31f6";
        };
        proxied = "!is(genshin.lialh4.cyou)";
        ip6Domains = [
          "genshin.lialh4.cyou{hostid6=[::10,::20]}"
        ];
      };
      cloudflared = {
        enable = true;
        tunnels = {
          a00f657a-254c-496a-bc41-6cb0d6ec4535 = {
            default = "http_status:404";
            credentialsFile =
              config.age.secretsV2.devices.LiAlH4-Server.cloudflared.tunnels.LiAlH4-Server.credentialsFile.path;
            ingress = {
              "hsr.lialh4.cyou" = "ssh://localhost:22";
            };
          };
        };
      };
      hermes = {
        enable = true;
        allowNixAccess = true;
        environmentFiles = [ config.age.secretsV2.devices.LiAlH4-Server.hermes.environmentFile.path ];
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
      network.mihoyo.extraConfig.external-controller = "[::]:9090";
      podman.enable = true;
      qbittorrent.enable = true;
      samba = {
        enable = true;
        passwordFiles.lialh4 =
          config.age.secretsV2.devices.LiAlH4-Server.samba.users.lialh4.passwordFile.path;
        shares.data = {
          path = "/mnt/data/lialh4";
          readOnly = false;
          user = "lialh4";
          group = "users";
        };
      };
      secureboot.enable = true;
    };
    system.version-when-installed = "25.11";
  };

  services = {
    samba.settings.global.port = 14159;
    firewalld = {
      services.samba-lialh4.ports = [
        {
          port = 14159;
          protocol = "tcp";
        }
      ];
      zones = {
        public.services = [ "samba-lialh4" ];
        trusted.sources = [
          { address = "fd00::/64"; }
          { address = "192.168.1.0/24"; }
        ];
      };
    };
  };

  systemd.services.cloudflare-ddns = {
    environment = {
      IP6_DETECTION_FILTER = "!addr-in(fd00::/64)";
    };
    serviceConfig.RestrictAddressFamilies = [ "AF_NETLINK" ];
  };

  networking.hostName = "LiAlH4-Server";
  time.timeZone = "Asia/Shanghai";
  nixpkgs.hostPlatform = "x86_64-linux";
}

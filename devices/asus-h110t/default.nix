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
        ip6Filter = "!addr-in(fd00::/64)";
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
      network = {
        firewalld = {
          services = {
            ssh-lialh4.ports = [
              {
                port = 14159;
                protocol = "tcp";
              }
            ];
            samba-lialh4.ports = [
              {
                port = 26535;
                protocol = "tcp";
              }
            ];
            qbittorrent-lialh4.ports =
              map
                (x: {
                  port = 23846;
                  protocol = x;
                })
                [
                  "tcp"
                  "udp"
                ];
          };
          zones = {
            public.services = [
              "dhcpv6-client"
              "ssh-lialh4"
              "samba-lialh4"
            ];
            trusted.sources = [
              { address = "fd00::/64"; }
              { address = "192.168.1.0/24"; }
            ];
          };
        };
        mihoyo.extraConfig.external-controller = "[::]:9090";
      };
      podman.enable = true;
      qbittorrent.enable = true;
      samba = {
        enable = true;
        port.tcp.alts = [ 26535 ];
        passwordFile.lialh4 =
          config.age.secretsV2.devices.LiAlH4-Server.samba.users.lialh4.passwordFile.path;
        share.data = {
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

  services.openssh.ports = [
    22
    14159
  ];

  time.timeZone = "Asia/Shanghai";
}

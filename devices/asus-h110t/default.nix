{
  config,
  lib,
  pkgs,
  scopes,
  ...
}:
{
  imports = [
    (lib.nix-tree-modules.mkTree {
      inherit scopes;
      scopeName = "device";
      dir = ./fs;
      base = [ "fs" ];
    })
    (lib.nix-tree-modules.mkTree {
      inherit scopes;
      scopeName = "device";
      dir = ./users;
      base = [ "users" ];
    })
  ];

  liuxu = {
    nixos = {
      bluetooth.enable = true;
      builder.enable = true;
      caddy.port = 50288;
      cloudflare-ddns = {
        enable = true;
        credentialsFile = config.vaultix.templates."cloudflare-ddns/credentials".path;
        provider = {
          ipv4 = "none";
          ipv6 = "local.iface:enp0s31f6";
        };
        ip6Filter = "!addr-in(fd00::/64)";
        proxied = "!is(genshin.lialh4.cyou)";
        ip6Domains = [
          "genshin.lialh4.cyou{hostid6=[::10,::20]}"
          # "vaultwarden.lialh4.cyou{hostid6=[::10,::20]}"
        ];
      };
      cloudflared = {
        enable = true;
        tunnels = {
          a00f657a-254c-496a-bc41-6cb0d6ec4535 = {
            default = "http_status:404";
            credentialsFile = config.vaultix.templates."cloudflared/tunnels/LiAlH4-Server/credentials".path;
            ingress = {
              "hsr.lialh4.cyou" = "ssh://localhost:22";
              "vaultwarden.lialh4.cyou" = {
                service = "https://localhost:${config.liuxu.nixos.caddy.port}";
                originRequest.originServerName = "vaultwarden.lialh4.cyou";
              };
              "matrix.lialh4.cyou" = {
                service = "https://localhost:${config.liuxu.nixos.caddy.port}";
                originRequest.originServerName = "matrix.lialh4.cyou";
              };
              "fedi.lialh4.cyou" = {
                service = "https://localhost:${config.liuxu.nixos.caddy.port}";
                originRequest.originServerName = "fedi.lialh4.cyou";
              };
            };
          };
        };
      };
      continuwuity = {
        enable = true;
        settings.global = {
          allow_registration = true;
          server_name = "lialh4.cyou";
          well_known.client = "https://matrix.lialh4.cyou";
          trusted_servers = [
            "mat.stelpolva.moe"
            "catgirl.cloud"
            "unredacted.org"
            "matrix.org"
          ];
        };
      };
      kernel.package = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
      misskey = {
        enable = true;
        database.createLocally = true;
        redis.createLocally = true;
        meilisearch.createLocally = true;
        meilisearch.keyFile = config.vaultix.secrets."meilisearch/masterKey".path;
        settings = {
          url = "https://fedi.lialh4.cyou/";
          mediaProxy = "https://misskey-media-proxy.lialh4.cyou";
          allowedPrivateNetworks = [ "198.18.0.0/15" ];
          fulltextSearch.provider = "meilisearch";
          meilisearch.index = "fedi_lialh4_cyou";
          setupPassword = "@SETUP_PASSWORD@";
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
            caddy-lialh4.ports =
              map
                (x: {
                  port = 50288;
                  protocol = x;
                })
                [
                  "tcp"
                  "udp"
                ];
          };
          zones = {
            public.services = [
              "ssh-lialh4"
              "samba-lialh4"
              "qbittorrent-lialh4"
              "caddy-lialh4"
            ];
            trusted.sources = [
              { address = "fd00::/64"; }
              { address = "192.168.1.0/24"; }
            ];
          };
        };
        mihoyo.settings.external-controller = "[::]:9090";
      };
      podman.enable = true;
      qbittorrent.enable = true;
      samba = {
        enable = true;
        port.tcp.alts = [ 26535 ];
        passwordFile.lialh4 = config.vaultix.secrets."samba/users/lialh4/password".path;
        share.data = {
          path = "/mnt/data/lialh4";
          readOnly = false;
          user = "lialh4";
          group = "users";
        };
      };
      secureboot.enable = true;
      ssh.ports = [
        22
        14159
      ];
      vaultix = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHgPw52HnxnsDNsnUxOLdMxfMiRdF7T0zbqO6dlBFgZ";
        localMachine = {
          beforeUserborn = [ "users/lialh4/hashedPassword" ];
          secrets = {
            "cloudflare-ddns/apiToken" = { };
            "cloudflared/accountTag" = { };
            "cloudflared/tunnels/LiAlH4-Server/tunnelId" = { };
            "cloudflared/tunnels/LiAlH4-Server/tunnelSecret" = { };
            "cloudflared/tunnels/LiAlH4-Server/endpoint" = { };
            "samba/users/lialh4/password" = { };
            "users/lialh4/hashedPassword" = { };
            "pin/users/lialh4/hashedPassword" = { };
            "misskey/setupPassword" = {
              owner = "misskey";
              group = "misskey";
              mode = "0400";
            };
            "meilisearch/masterKey" = {
              owner = "misskey";
              group = "misskey";
              mode = "0400";
            };
          };
          templates =
            let
              ph = config.vaultix.placeholder;
            in
            {
              "cloudflare-ddns/credentials" = {
                content = "CLOUDFLARE_API_TOKEN=${ph."cloudflare-ddns/apiToken"}";
                owner = config.users.users.cloudflare-ddns.name;
                group = config.users.users.cloudflare-ddns.group;
              };
              "cloudflared/tunnels/LiAlH4-Server/credentials".content = builtins.toJSON {
                AccountTag = ph."cloudflared/accountTag";
                TunnelID = ph."cloudflared/tunnels/LiAlH4-Server/tunnelId";
                TunnelSecret = ph."cloudflared/tunnels/LiAlH4-Server/tunnelSecret";
                Endpoint = ph."cloudflared/tunnels/LiAlH4-Server/endpoint";
              };
            };
        };
      };
      vaultwarden.enable = true;
    };
    system.version-when-installed = "25.11";
  };

  services.meilisearch = {
    masterKeyFile = config.vaultix.secrets."meilisearch/masterKey".path;
    settings.env = "production";
  };

  systemd.services.misskey.preStart = lib.mkAfter ''
    for f in /run/misskey/default.yml /run/misskey/default.json; do
      ${pkgs.replace-secret}/bin/replace-secret '@SETUP_PASSWORD@' ${
        config.vaultix.secrets."misskey/setupPassword".path
      } "$f"
    done
  '';
}

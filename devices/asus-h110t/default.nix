{
  config,
  pkgs,
  root,
  ...
}:
{
  imports = [
    ./fs
    ./users
  ];

  liuxu = {
    nixos = {
      bluetooth.enable = true;
      builder.enable = true;
      cloudflare-ddns = {
        enable = true;
        credentialsFile = config.sops.templates."localMachine/cloudflare-ddns/credentials".path;
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
              config.sops.secrets."localMachine/cloudflared/tunnels/LiAlH4-Server/credentials".path;
            ingress = {
              "hsr.lialh4.cyou" = "ssh://localhost:22";
            };
          };
        };
      };
      kernel.package = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
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
        passwordFile.lialh4 = config.sops.secrets."localMachine/samba/users/lialh4/password".path;
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

  sops = {
    secrets =
      let
        sopsFile = "${root}/sops/LiAlH4-Server.yaml";
      in
      {
        "localMachine/cloudflare-ddns/apiToken" = {
          inherit sopsFile;
        };
        "localMachine/cloudflared/accountTag" = { };
        "localMachine/cloudflared/tunnels/LiAlH4-Server/tunnelId" = { };
        "localMachine/cloudflared/tunnels/LiAlH4-Server/tunnelSecret" = { };
        "localMachine/cloudflared/tunnels/LiAlH4-Server/endpoint" = { };
        "localMachine/samba/users/lialh4/password" = {
          inherit sopsFile;
        };
        "localMachine/users/lialh4/hashedPassword" = {
          inherit sopsFile;
          neededForUsers = true;
        };
      };
    templates =
      let
        ph = config.sops.placeholder;
      in
      {
        "localMachine/cloudflare-ddns/credentials" = {
          content = "CLOUDFLARE_API_TOKEN=${ph."localMachine/cloudflare-ddns/apiToken"}";
          owner = config.users.users.cloudflare-ddns.name;
          group = config.users.users.cloudflare-ddns.group;
        };
        "localMachine/cloudflared/tunnels/LiAlH4-Server/credentials".content = builtins.toJSON {
          AccountTag = ph."localMachine/cloudflared/accountTag";
          TunnelID = ph."localMachine/cloudflared/tunnels/LiAlH4-Server/tunnelId";
          TunnelSecret = ph."localMachine/cloudflared/tunnels/LiAlH4-Server/tunnelSecret";
          Endpoint = ph."localMachine/cloudflared/tunnels/LiAlH4-Server/endpoint";
        };
      };
  };

  services.openssh.ports = [
    22
    14159
  ];
}

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
      configFile = /run/mihoyo/config.yaml;
    };

    systemd.tmpfiles.settings.mihoyo."/run/mihoyo/config.yaml".f = {
      mode = "0600";
      argument = pkgs.formats.yaml_1_2 { }.generate "mihoyo" {
        allow-lan = false;
        ipv6 = true;
        unified-delay = true;
        tcp-concurrent = true;
        external-controller = "[::1]:9090";
        profile = {
          store-selected = true;
          store-fakeip = true;
        };

        geodata-mode = true;
        geo-auto-update = true;
        geox-url = {
          geoip = "https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat";
          geosite = "https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat";
        };

        sniffer = {
          enable = true;
          parse-pure-ip = true;
          force-dns-mapping = true;
          override-destination = true;
          sniff = {
            HTTP = {
              ports = [
                80
              ];
            };
            TLS = {
              ports = [
                443
              ];
            };
            QUIC = {
              ports = [
                443
              ];
            };
          };
        };

        dns = {
          enable = true;
          ipv6 = true;
          prefer-h3 = false; # Not Recommend
          respect-rules = true; # enable them all.
          cache-algorithm = "arc";
          enhanced-mode = "fake-ip";
          nameserver-policy = {
            "geosite:cn" = [
              "https://223.5.5.5/dns-query"
              "https://119.29.29.29/dns-query"
            ];
          };
          default-nameserver = [
            "https://223.5.5.5/dns-query"
            "https://119.29.29.29/dns-query"
          ];
          proxy-server-nameserver = [
            "https://223.5.5.5/dns-query"
            "https://119.29.29.29/dns-query"
          ];
          direct-nameserver = [
            "https://223.5.5.5/dns-query"
            "https://119.29.29.29/dns-query"
          ];
          direct-nameserver-follow-policy = false;
          nameserver = [
            "https://1.1.1.1/dns-query"
            "https://8.8.8.8/dns-query"
          ];
        };

        mixed-port = 7890;

        tun = {
          enable = true;
          stack = "mixed";
          device = "mihoyo";
          auto-route = true;
          strict-route = true;
          auto-redirect = true;
          auto-detect-interface = true;
          gso = true;
          dns-hijack = [
            "any:53"
            "tcp://any:53"
          ];
        };

        proxies = [
          {
            name = "Dns";
            type = "dns";
            udp = true;
            tfo = true;
            mptcp = true;
          }
          {
            name = "Direct";
            type = "direct";
            udp = true;
            tfo = true;
            mptcp = true;
          }
        ];

        proxy-providers = {
          alink = {
            type = "http";
            url = import ./secret;
            interval = 21600;
            health-check = {
              enable = true;
              lazy = true;
              interval = 300;
              timeout = 5000;
              expected-status = 204;
              url = "https://cp.cloudflare.com";
            };
          };
        };

        proxy-groups = [
          {
            name = "General";
            type = "select";
            include-all = true;
            exclude-type = "dns";
            lazy = true;
            interval = 300;
            timeout = 5000;
            expected-status = 204;
            url = "https://cp.cloudflare.com";
          }
          {
            name = "AI Abroad";
            type = "select";
            include-all = true;
            exclude-type = "dns";
            lazy = true;
            interval = 300;
            timeout = 5000;
            expected-status = 204;
            url = "https://cp.cloudflare.com";
          }
          {
            name = "HK Auto";
            type = "url-test";
            include-all = true;
            exclude-type = "dns|direct";
            filter = "^🇭🇰";
            lazy = true;
            interval = 300;
            timeout = 5000;
            expected-status = 204;
            url = "https://cp.cloudflare.com";
          }
          {
            name = "TW Auto";
            type = "url-test";
            include-all = true;
            exclude-type = "dns|direct";
            filter = "^🇹🇼";
            lazy = true;
            interval = 300;
            timeout = 5000;
            expected-status = 204;
            url = "https://cp.cloudflare.com";
          }
          {
            name = "JP Auto";
            type = "url-test";
            include-all = true;
            exclude-type = "dns|direct";
            filter = "^🇯🇵";
            lazy = true;
            interval = 300;
            timeout = 5000;
            expected-status = 204;
            url = "https://cp.cloudflare.com";
          }
          {
            name = "SG Auto";
            type = "url-test";
            include-all = true;
            exclude-type = "dns|direct";
            filter = "^🇸🇬";
            lazy = true;
            interval = 300;
            timeout = 5000;
            expected-status = 204;
            url = "https://cp.cloudflare.com";
          }
          {
            name = "UK Auto";
            type = "url-test";
            include-all = true;
            exclude-type = "dns|direct";
            filter = "^🇬🇧";
            lazy = true;
            interval = 300;
            timeout = 5000;
            expected-status = 204;
            url = "https://cp.cloudflare.com";
          }
          {
            name = "US Auto";
            type = "url-test";
            include-all = true;
            exclude-type = "dns|direct";
            filter = "^🇺🇸";
            lazy = true;
            interval = 300;
            timeout = 5000;
            expected-status = 204;
            url = "https://cp.cloudflare.com";
          }
        ];

        rules = [
          "DST-PORT, 53, Dns"
          "GEOIP, lan, Direct, no-resolve"
          "GEOSITE, private, Direct, no-resolve"
          "GEOSITE, category-ai-!cn, AI Abroad"
          "GEOSITE, cn, Direct"
          "GEOIP, cn, Direct"
          "MATCH, General"
        ];
      };
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

{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.hoyofall.nixosModules.default ];

  options.liuxu.nixos = {
    internal.final.network.song-of-welkin-moon.enable = lib.liuxu.mkComputedSwitchOption (
      config.liuxu.nixos.network.enable && config.liuxu.nixos.network.song-of-welkin-moon.enable
    );
    network.song-of-welkin-moon.enable = lib.liuxu.mkOsSwitchOnOption "Whether to enable Genshin Impact: Song of Welkin Moon.";
  };
  config = lib.mkIf config.liuxu.nixos.internal.final.network.song-of-welkin-moon.enable {
    sops.templates."hoyofall/default".content = "DEFAULT_URL=${
      config.sops.placeholder."mihoyo/providerUrls/alink"
    }";
    services = {
      hoyofall = {
        enable = true;
        singboxIntegration.enable = true;
        settings = {
          subscriptions.default = {
            userAgent = "clash.meta/v1.19.0";
            urlEnv = "DEFAULT_URL";
          };
          groups.custom = {
            hk-auto = {
              type = "urltest";
              includeRegexes = [ "^🇭🇰" ];
            };
            tw-auto = {
              type = "urltest";
              includeRegexes = [ "^🇹🇼" ];
            };
            sg-auto = {
              type = "urltest";
              includeRegexes = [ "^🇸🇬" ];
            };
            uk-auto = {
              type = "urltest";
              includeRegexes = [ "^🇬🇧" ];
            };
            us-auto = {
              type = "urltest";
              includeRegexes = [ "^🇺🇸" ];
            };
            ca-auto = {
              type = "urltest";
              includeRegexes = [ "^🇨🇦" ];
            };
            default = {
              type = "selector";
              includeProxies = true;
              includeCustomGroups = true;
              includeDirect = true;
            };
          };
        };
        environmentFile = config.sops.templates."hoyofall/default".path;
      };
      sing-box = {
        enable = true;
        package = pkgs.unstable.sing-box;
        settings = {
          experimental = {
            clash_api = {
              external_controller = "[::1]:9090";
              external_ui = "ui";
            };
            cache_file = {
              enabled = true;
              store_dns = true;
              store_fakeip = true;
            };
          };
          outbounds = [
            {
              tag = "direct";
              type = "direct";
            }
          ];
          inbounds = [
            {
              type = "tun";
              strict_route = true;
              auto_route = true;
              auto_redirect = true;
              address = [
                "172.18.0.1/30"
                "fdfe:dcba:9876::1/126"
              ];
            }
          ];
          dns = {
            optimistic = true;
            reverse_mapping = true;
            strategy = "prefer_ipv6";
            final = "cloudflare";
            servers = [
              {
                tag = "cloudflare";
                type = "tls";
                server = "1.1.1.1";
              }
              {
                tag = "alidns";
                type = "tls";
                server = "223.5.5.5";
              }
              {
                tag = "fakeip";
                type = "fakeip";
                inet4_range = "198.18.0.0/15";
                inet6_range = "fc00::/18";
              }
            ];
            rules = [
              {
                action = "evaluate";
                server = "cloudflare";
              }
              # {
              #   query_type = [
              #     "A"
              #     "AAAA"
              #   ];
              #   server = "fakeip";
              # }
              {
                match_response = true;
                rule_set = [
                  "geosite-cn"
                  "geoip-cn"
                ];
                server = "alidns";
              }
            ];
          };
          route = {
            auto_detect_interface = true;
            find_process = true;
            find_neighbor = true;
            default_domain_resolver = "alidns";
            final = "default";
            rules = [
              { action = "sniff"; }
              {
                type = "logical";
                mode = "or";
                rules = [
                  {
                    protocol = "dns";
                  }
                  {
                    port = 53;
                  }
                ];
                action = "hijack-dns";
              }
              {
                ip_is_private = true;
                outbound = "direct";
              }
              {
                rule_set = "geosite-cn";
                outbound = "direct";
              }
              {
                rule_set = "geoip-cn";
                outbound = "direct";
              }
            ];
            rule_set = [
              {
                tag = "geosite-cn";
                type = "remote";
                format = "binary";
                download_detour = "default";
                url = "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-cn.srs";
              }
              {
                tag = "geoip-cn";
                type = "remote";
                format = "binary";
                download_detour = "default";
                url = "https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set/geoip-cn.srs";
              }
            ];
          };
        };
      };
    };
    systemd.services.hoyofall = {
      requires = [ "sops-install-secrets.service" ];
      after = [ "sops-install-secrets.service" ];
    };
  };
}

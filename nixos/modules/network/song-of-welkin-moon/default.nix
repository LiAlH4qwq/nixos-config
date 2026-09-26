{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hoyofall.nixosModules.default
    ./settings
  ];

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
          groups.custom =
            {
              hk = "🇭🇰";
              tw = "🇹🇼";
              sg = "🇸🇬";
              uk = "🇬🇧";
              us = "🇺🇸";
              ca = "🇨🇦";
            }
            |>
              lib.mapAttrs' (
                n: v: {
                  name = "${n}-auto";
                  value = {
                    type = "urltest";
                    includeRegexes = [ "^${v}" ];
                  };
                }
              )
              // {
                default = {
                  type = "selector";
                  default = "hk-auto";
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
      };
    };
    systemd.services.hoyofall =
      let
        after = [ "sops-install-secrets.service" ];
      in
      {
        inherit after;
        requires = after;
      };
  };
}

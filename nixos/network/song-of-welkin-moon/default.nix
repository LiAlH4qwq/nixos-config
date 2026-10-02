{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.hoyofall.nixosModules.default ];

  here = {
    switch.premise = [ "network" ];
    config = {
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
              let
                regMap = {
                  hk = "🇭🇰";
                  tw = "🇹🇼";
                  sg = "🇸🇬";
                  uk = "🇬🇧";
                  us = "🇺🇸";
                  ca = "🇨🇦";
                };
              in
              (
                regMap
                |> lib.mapAttrs' (
                  n: v: {
                    name = "${n}-auto";
                    value = {
                      level = 1;
                      type = "urltest";
                      includeRegexes = [ "^${v}" ];
                    };
                  }
                )
              )
              // (
                {
                  default = "hk-auto";
                  ai-not-cn = "tw-auto";
                  github = "hk-auto";
                }
                |> builtins.mapAttrs (
                  _: v: {
                    level = 2;
                    type = "selector";
                    default = v;
                    includeLevels = [ 1 ];
                    includeProxies = true;
                    includeDirect = true;
                  }
                )
              );
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
  };
}

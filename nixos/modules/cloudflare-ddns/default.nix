{ config, lib, ... }: {
  imports = [
    (lib.mkAliasOptionModule [ "liuxu" "nixos" "cloudflare-ddns" ] [ "services" "cloudflare-ddns" ])
  ];

  options.services.cloudflare-ddns.ip6Filter = lib.mkOption {
    type = with lib.types; nullOr singleLineStr;
    default = null;
    example = "!addr-in(fd00::/64)";
    description = ''
      Liuxu: IPV6 filter of cloudflare-ddns.
    '';
  };

  config =
    let
      cfg = config.liuxu.nixos.cloudflare-ddns;
    in
    lib.mkIf cfg.enable (
      lib.mkMerge [
        {
          # Fix finding network interfaces.
          systemd.services.cloudflare-ddns.serviceConfig.RestrictAddressFamilies = [ "AF_NETLINK" ];
        }
        (lib.mkIf (cfg.ip6Filter != null) {
          systemd.services.cloudflare-ddns.environment.IP6_DETECTION_FILTER = cfg.ip6Filter;
        })
      ]
    );
}

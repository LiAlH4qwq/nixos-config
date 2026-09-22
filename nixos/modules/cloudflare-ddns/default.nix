{
  config,
  lib,
  pkgs,
  ...
}:
{
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
        {
          networking.networkmanager.dispatcherScripts = [
            {
              type = "basic";
              source =
                let
                  systemctl = "systemctl" |> lib.getExe' config.systemd.package;
                in
                lib.getExe
                <| pkgs.writers.writeNuBin "cloudflare-ddns-ip-change" ''
                  def main [iface: string, action: string] {
                    if $action in [up dhcp6-change connectivity-change] {
                      ^${systemctl} restart --no-block cloudflare-ddns.service
                    }
                  }
                '';
            }
          ];
        }
      ]
    );
}

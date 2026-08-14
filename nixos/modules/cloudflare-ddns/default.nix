{ lib, ... }: {
  imports = [
    (lib.mkAliasOptionModule [ "liuxu" "nixos" "cloudflare-ddns" ] [ "services" "cloudflare-ddns" ])
  ];
}

{ lib, ... }: {
  imports = [
    (lib.mkAliasOptionModule
      [
        "liuxu"
        "nixos"
        "cloudflared"
      ]
      [
        "services"
        "cloudflared"
      ]
    )
  ];
}

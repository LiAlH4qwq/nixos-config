{ lib, ... }: {
  imports = [
    (lib.mkAliasOptionModule
      [
        "liuxu"
        "nixos"
        "cloudflared"
        #"tunnels"
      ]
      [
        "services"
        "cloudflared"
        #"tunnels"
      ]
    )
  ];
}

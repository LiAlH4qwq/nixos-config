{
  lib,
  root,
  scopes,
  ...
}:
{
  imports = [
    (lib.nix-tree-modules.mkTree {
      inherit scopes;
      scopeName = "device";
      dir = ./fs;
      base = [ "fs" ];
    })
    (lib.nix-tree-modules.mkTree {
      inherit scopes;
      scopeName = "device";
      dir = ./users;
      base = [ "users" ];
    })
  ];

  liuxu.system.version-when-installed = "26.05";

  # No `pin/users/<user>/hashedPassword` secret is configured for this host, so the
  # opt-out `liuxu.nixos.pin` must be disabled (it would otherwise emit an empty
  # pwdfile, which is invalid).
  liuxu.nixos.pin.enable = false;

  sops.secrets."localMachine/users/lialh4/hashedPassword" = {
    sopsFile = "${root}/sops/LiAlH4-WorkPC.yaml";
    neededForUsers = true;
  };
}

{
  lib,
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

  liuxu = {
    # No `pin/users/<user>/hashedPassword` secret is configured for this host.
    nixos.pin.enable = false;
    system.version-when-installed = "26.05";
  };
}

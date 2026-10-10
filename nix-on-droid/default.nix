{
  lib,
  root,
  scopes,
  ...
}:
{
  imports = [
    (root + "/system")
    (lib.nix-tree-modules.mkTree {
      inherit scopes;
      scopeName = "nix-on-droid";
      dir = ./nixos-shim;
      base = [ ];
    })
    (lib.nix-tree-modules.mkTree {
      inherit scopes;
      scopeName = "nix-on-droid";
      dir = ./proot;
      base = [ ];
    })
  ];
}

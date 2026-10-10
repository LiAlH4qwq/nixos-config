{
  lib,
  scopes,
  ...
}:
let
  tree =
    base: dir:
    lib.nix-tree-modules.mkTree {
      inherit scopes base dir;
      scopeName = "system";
    };
in
{
  imports = [
    (tree [ ] ./modules)
    (tree [ "nix" ] ./nix)
  ];
}

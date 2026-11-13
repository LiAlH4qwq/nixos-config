{
  lib,
  scopes,
  ...
}:
{
  imports =
    let
      tree =
        base: dir:
        lib.nix-tree-modules.mkTree {
          inherit scopes base dir;
          scopeName = "system";
        };
    in
    [
      (tree [ ] ./modules)
      (tree [ "nix" ] ./nix)
    ];
}

# Pure utilities for the strict-tree switch system.  No settings live here:
# the scope registry is a separate module tree evaluated with `evalModules`
# (see `<root>/scope`), and is passed in by the caller.
{ lib }:
let
  switch = import ./switch.nix { inherit lib; };
  tree = import ./tree.nix { inherit lib; };
in
{
  inherit (switch)
    mkSwitchRefType
    mkPremiseType
    mkSwitchOptionType
    evalPremise
    translateModule
    ;
  inherit (tree) mkTree;
}

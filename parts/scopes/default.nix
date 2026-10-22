# Evaluate this repo's scope data (under `<root>/scopes`) with the schema and
# evaluator from upstream `nix-tree-modules`, then inject the result as a
# flake-parts module argument so every part can forward it into NixOS /
# home-manager.
{ inputs, root, ... }:
{
  _module.args.scopes = inputs.nix-tree-modules.lib.mkScopes {
    modules = [ (root + "/scopes") ];
  };
}

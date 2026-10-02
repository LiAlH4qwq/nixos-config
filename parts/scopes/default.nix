# Evaluate the scope registry (settings under `<root>/scopes`) once through the
# nixpkgs module system and inject it as a flake-parts module argument, so it
# is available to every part and can be forwarded into NixOS / home-manager.
{ lib, root, ... }:
let
  scopeEval = lib.evalModules { modules = [ (root + "/scopes") ]; };
in
{
  _module.args.scopes = scopeEval.config.scopes;
}

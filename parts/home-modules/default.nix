{ root, ... }:
{
  flake.homeModules =
    let
      module.imports = [ (root + "/home") ];
    in
    {
      default = module;
      liuxu = module;
    };
}

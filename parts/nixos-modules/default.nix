{ root, ... }:
{
  flake.nixosModules =
    let
      module.imports = [ (root + "/nixos") ];
    in
    {
      default = module;
      liuxu = module;
    };
}

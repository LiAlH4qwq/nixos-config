{ self, ... }:
{
  flake.homeModules =
    let
      module = {
        imports = [ "${self}/home" ];
      };
    in
    {
      default = module;
      liuxu = module;
    };
}

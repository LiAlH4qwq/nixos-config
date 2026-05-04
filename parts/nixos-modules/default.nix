{ self, ... }:
{
  flake.nixosModules =
    let
      module = {
        imports = [ "${self}/nixos" ];
      };
    in
    {
      default = module;
      nixos = module;
      liuxu = module;
    };
}

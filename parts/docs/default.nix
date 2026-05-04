{
  inputs,
  lib,
  self,
  ...
}:
{
  perSystem =
    { pkgs, system, ... }:
    let
      eval = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs self;
          inherit (self) lib;
        };
        modules = [
          self.nixosModules.liuxu
          { _module.check = false; }
        ];
      };
      optionsDoc = pkgs.nixosOptionsDoc {
        options = eval.options;
        transformOptions =
          opt:
          opt
          // {
            visible = lib.hasPrefix "liuxu" (lib.concatStringsSep "." opt.loc);
          };
      };
    in
    {
      packages.nixos-options-doc = optionsDoc.optionsCommonMark;
    };
}

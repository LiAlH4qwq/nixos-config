{
  inputs,
  lib,
  self,
  ...
}:
{
  perSystem = { pkgs, system, ... }: {
    packages =
      let
        eval = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs self;
            inherit (self) lib;
          };
          modules = [
            self.nixosModules.liuxu
          ];
        };
        optionsDoc = pkgs.nixosOptionsDoc {
          inherit (eval) options;
          transformOptions =
            opt:
            opt
            // {
              visible = (builtins.head opt.loc) == "liuxu";
            };
        };
        doc = optionsDoc.optionsCommonMark;
      in
      {
        inherit doc;
        default = doc;
      };
  };
}

{ inputs, ... }: {
  here = { };
  imports = [ inputs.lix-module.nixosModules.default ];
}

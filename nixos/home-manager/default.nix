{
  flakeConfig,
  inputs,
  lib,
  options,
  root,
  scopes,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.default ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    overwriteBackup = true;
    backupFileExtension = "bak";
    extraSpecialArgs = {
      inherit
        inputs
        lib
        root
        scopes
        ;
      osOptions = options;
    };
    sharedModules = [
      flakeConfig.flake.homeModules.liuxu
    ];
  };
}

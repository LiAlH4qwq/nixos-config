{
  flakeConfig,
  inputs,
  lib,
  options,
  root,
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
      inherit inputs lib root;
      osOptions = options;
    };
    sharedModules = [
      flakeConfig.flake.homeModules.liuxu
    ];
  };
}

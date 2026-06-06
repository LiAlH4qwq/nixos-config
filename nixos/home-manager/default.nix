{
  inputs,
  lib,
  self,
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
      inherit inputs self;
      lib' = lib;
    };
    sharedModules = [
      self.homeModules.liuxu
    ];
  };
}

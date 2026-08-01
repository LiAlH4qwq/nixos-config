{
  inputs,
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
      inherit (self) lib;
    };
    sharedModules = [
      self.homeModules.liuxu
    ];
  };
}

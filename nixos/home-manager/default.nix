{
  inputs,
  options,
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
      osOptions = options;
    };
    sharedModules = [
      self.homeModules.liuxu
    ];
  };
}

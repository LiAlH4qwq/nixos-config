{ inputs, self, ... }:
{
  imports = [ inputs.home-manager.nixosModules.default ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    overwriteBackup = true;
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit inputs self; };
    sharedModules = [
      self.homeModules.liuxu
    ];
  };
}

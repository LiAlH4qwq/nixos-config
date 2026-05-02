{ inputs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.default ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    overwriteBackup = true;
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [
      "${inputs.self}/user"
    ];
  };
}

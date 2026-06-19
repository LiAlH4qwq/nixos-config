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
      # It's strange that it needs explictly written like this.
      # Looks like `lib` here already has `liuxu` prop.
      # But without written it again, it will failed.
      lib = lib.extend (
        _: _: {
          inherit (inputs.home-manager.lib) hm;
          inherit (lib) liuxu;
        }
      );
    };
    sharedModules = [
      self.homeModules.liuxu
    ];
  };
}

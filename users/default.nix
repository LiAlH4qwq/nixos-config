{ pkgs, ... }: {
  imports = [
    ./lialh4
  ];
  
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };
}

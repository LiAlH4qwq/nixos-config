_: {
  imports = [
    ./lialh4
  ];

  users = {
    mutableUsers = false;
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };
}

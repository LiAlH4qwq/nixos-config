{ pkgs, ... }: {
  imports = [
    ./lialh4.nix
  ]
  
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}

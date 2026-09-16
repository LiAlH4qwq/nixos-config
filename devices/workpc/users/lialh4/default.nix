{ config, pkgs, ... }:
{
  users.extraUsers.lialh4 = {
    password = "temp";
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = [
      "wheel"
    ];
  };
  home-manager.users.lialh4 = {
    liuxu.home = {
      gui = {
        umbriel.enable = true;
      };
      opencode.enable = true;
    };
  };
}

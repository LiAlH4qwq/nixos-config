{ config, pkgs, ... }:
{
  liuxu.nixos.users.lialh4 = {
    id = config.liuxu.id.lialh4;
    hashedPasswordFile = config.sops.secrets."localMachine/users/lialh4/hashedPassword".path;
  };
  users.extraUsers.lialh4 = {
    useDefaultShell = true;
    extraGroups = [
      "wheel"
    ];
  };
  home-manager.users.lialh4 = {
    liuxu.home = {
      gui.umbriel.enable = true;
      opencode.enable = true;
    };
  };
}

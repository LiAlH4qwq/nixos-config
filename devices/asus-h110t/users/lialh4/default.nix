{ config, ... }:
{
  liuxu.nixos.users.lialh4 = {
    id = config.liuxu.id.lialh4;
    hashedPasswordFile = config.sops.secrets."localMachine/users/lialh4/hashedPassword".path;
  };

  users.extraUsers.lialh4 = {
    useDefaultShell = true;
    linger = true;
    extraGroups = [ "wheel" ];
  };
  home-manager.users.lialh4 = {
    services.syncthing.guiAddress = "[::]:8384";
  };
  services.libpam-pwdfile-rs.instances.pin.users.lialh4.hashedPasswordFile =
    config.sops.secrets."localMachine/pin/users/lialh4/hashedPassword".path;
}

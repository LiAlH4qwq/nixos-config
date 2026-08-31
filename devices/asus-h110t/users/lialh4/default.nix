{ config, ... }:
{
  liuxu.nixos.users.lialh4.id = config.liuxu.id.lialh4;

  users.extraUsers.lialh4 = {
    isNormalUser = true;
    useDefaultShell = true;
    linger = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.age.secretsV2.devices.LiAlH4-Server.users.lialh4.password.path;
  };
  home-manager.users.lialh4 = {
    services.syncthing.guiAddress = "[::]:8384";
  };
  libpam-pwdfile-rs = {
    pin.users.lialh4.secret = "$y$j9T$bjCgDKQCZmMhnca0Jw54X1$x4iqH6CXtKuBnFAPaO9M2Cdv6YMB.kPnFUBeGM4vUV4";
  };
}

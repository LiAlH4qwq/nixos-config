{ config, ... }:
{
  users.extraUsers.lialh4 = {
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.age.secrets."devices.LiAlH4-Server.users.lialh4.password".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPzvkOPfWZmx2zE6cJY4Qz+Z1dKXTgd6Y2I/RgIc86T"
    ];
  };
  home-manager.users.lialh4 = {
    liuxu.user = {
      gui.enable = false;
    };
  };
  libpam-pwdfile-rs = {
    pin.users.lialh4.secret = "$y$j9T$bjCgDKQCZmMhnca0Jw54X1$x4iqH6CXtKuBnFAPaO9M2Cdv6YMB.kPnFUBeGM4vUV4";
  };
}

{ config, ... }:
{
  environment.etc = {
    subuid = {
      target = "subuid";
      text = "lialh4:100000:65536";
    };
    subgid = {
      target = "subgid";
      text = "lialh4:100000:65536";
    };
  };

  users.extraUsers.lialh4 = {
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.age.secretsV2.devices.LiAlH4-Laptop.users.lialh4.password.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPzvkOPfWZmx2zE6cJY4Qz+Z1dKXTgd6Y2I/RgIc86T"
    ];
  };
  home-manager.users.lialh4 = {
    liuxu.home = {
      gui = {
        hyprland.enable = true;
        niri.enable = true;
        agl.enable = true;
      };
      opencode.enable = true;
      sdk.enable = true;
      internal.intransience.dirs = [ ".local/share/fonts" ];
    };
    services.podman = {
      enable = true;
      settings.storage.storage.graphRoot = "/mnt/data/lialh4/ProgramFiles/Podman";
    };
  };
  libpam-pwdfile-rs = {
    pin.users.lialh4.secret = "$y$j9T$bjCgDKQCZmMhnca0Jw54X1$x4iqH6CXtKuBnFAPaO9M2Cdv6YMB.kPnFUBeGM4vUV4";
  };
}

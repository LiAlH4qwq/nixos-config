{ config, pkgs, ... }:
{
  environment.etc = {
    # newuidmap/newgidmap open these with O_NOFOLLOW, so they must be real
    # files; with system.etc.overlay the default "symlink" mode would point
    # into the store and make rootless podman fail with ELOOP.
    subuid = {
      mode = "0644";
      text = "lialh4:100000:65536";
    };
    subgid = {
      mode = "0644";
      text = "lialh4:100000:65536";
    };
  };

  liuxu.nixos.users.lialh4 = {
    id = config.liuxu.id.lialh4;
    hashedPasswordFile = config.sops.secrets."localMachine/users/lialh4/hashedPassword".path;
  };

  users.extraUsers.lialh4 = {
    # useDefaultShell = true;
    shell = pkgs.nushell;
    extraGroups = [
      "wheel"
      "dialout"
    ];
  };
  home-manager.users.lialh4 = {
    liuxu.home = {
      gui = {
        hyprland.enable = true;
        niri.enable = true;
        umbriel.enable = true;
        agl.enable = true;
      };
      opencode.enable = true;
      sdk.enable = true;
      preservation.directories = [ ".local/share/fonts" ];
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

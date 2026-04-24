{ pkgs, ... }:
{
  imports = [
    ./fs
    ./users
  ];

  liuxu = {
    nixos = {
      bluetooth.enable = true;
      network = {
        enable = true;
        mihoyo.enable = true;
      };
      secureboot.enable = true;
      user-support = {
        gui = {
          enable = false;
          agl.enable = false;
          display-manager.enable = false;
        };
      };
    };
    system = {
      better-shell.enable = true; # Default enable
      brightness.enable = false;
      fingerprint.enable = false;
      helix.enable = true; # Default enable
      laptop.enable = false;
      pin.enable = true; # Default enable
      podman.enable = true;
      ssh.enable = true;
      virtualbox.enable = false;

      # Reflects NixOS version **when system get installed**.
      # Do not change it after install **unless needed**!
      version-when-installed = "25.11";

    };
  };

  networking.hostName = "LiAlH4-Server";
  time.timeZone = "Asia/Shanghai";
  nixpkgs.hostPlatform = "x86_64-linux";

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
  };
}

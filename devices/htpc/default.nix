{ pkgs, ... }:
{
  imports = [
    ./fs
    ./users
  ];

  liuxu = {
    nixos = {
      bluetooth.enable = true;
      brightness.enable = false;
      fingerprint.enable = false;
      laptop.enable = false;
      network = {
        enable = true;
        mihoyo.enable = true;
      };
      pin.enable = true;
      podman.enable = true;
      secureboot.enable = true;
      ssh-access.enable = true;
      user-support = {
        gui = {
          enable = false;
          agl.enable = false;
          display-manager.enable = false;
        };
      };
      virtualbox.enable = false;
    };
    system = {
      better-shell.enable = true; # Default enable
      helix.enable = true; # Default enable

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

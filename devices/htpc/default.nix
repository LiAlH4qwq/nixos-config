{ pkgs, ... }:
{
  imports = [
    ./fs
    ./users
  ];

  liuxu = {
    nixos = {
      network = {
        enable = true; # Default enable
        mihoyo.enable = true;
      };
      secureboot.enable = true;
      user-support = {
        gui = {
          agl.enable = false;
        };
      };
    };
    system = {
      better-shell.enable = true; # Default enable
      bluetooth.enable = true;
      brightness.enable = false;
      fingerprint.enable = false;
      helix.enable = true; # Default enable
      laptop.enable = false;
      pin.enable = true; # Default enable
      podman.enable = true;
      ssh.enable = true;
      user-support = {
        gui = {
          enable = false;
          display-manager.enable = false; # Default enable when enabling GUI and requires enabling GUI
        };
      };
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

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
  ];
}

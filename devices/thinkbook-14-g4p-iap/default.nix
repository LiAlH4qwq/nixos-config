{ pkgs, ... }:
{
  imports = [
    ./fs
    ./fingerprint
    ./users
  ];

  liuxu = {
    nixos = {
      bluetooth.enable = true;
      brightness.enable = true;
      fingerprint.enable = true;
      laptop.enable = true;
      network = {
        enable = true; # Default enable
        mihoyo.enable = true;
      };
      pin.enable = true; # Default enable
      podman.enable = true;
      secureboot.enable = true;
      ssh-access.enable = true;
      user-support = {
        gui = {
          enable = true;
          agl.enable = true;
          display-manager.enable = true; # Default enable when enabling GUI and requires enabling GUI
          # Default enable when enabling GUI.
          # Takes no effect when GUI is not enabled.
          intel-graphics.enable = true;
        };
      };
      virtualbox.enable = true;
    };
    system = {
      better-shell.enable = true; # Default enable
      helix.enable = true; # Default enable

      # Reflects NixOS version **when system get installed**.
      # Do not change it after install **unless needed**!
      version-when-installed = "25.11";

    };
  };

  networking.hostName = "LiAlH4-Laptop";
  time.timeZone = "Asia/Shanghai";
  nixpkgs.hostPlatform = "x86_64-linux";

  services.logind.settings.Login = {
    # 😭 The fingerprint reader is on the power button.
    HandlePowerKey = "ignore";
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandleLidSwitchDocked = "suspend-then-hibernate";
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30min
  '';
}

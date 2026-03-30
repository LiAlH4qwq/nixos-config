{ pkgs, ... }:
{
  imports = [
    ./fs
    ./fingerprint
    ./users
  ];

  liuxu.system = {
    better-shell.enable = true; # Default enable
    bluetooth.enable = true;
    brightness.enable = true;
    fingerprint.enable = true;
    helix.enable = true; # Default enable
    laptop.enable = true;
    network = {
      enable = true; # Default enable
      clash-verge.enable = true;
    };
    podman.enable = true;
    secureboot.enable = true;
    ssh.enable = true;
    user-support = {
      gui = {
        enable = false;
        display-manager.enable = true; # Default enable when enabling GUI and requires enabling GUI
      };
    };
    virtualbox.enable = true;
  };

  networking.hostName = "LiAlH4-Laptop-Nix";
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

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
  ];

  libpam-pwdfile-rs = {
    pin = {
      pwdfile = "/etc/pin";
      services = [
        "login"
        "polkit-1"
        "hyprlock"
      ];
    };
  };
}

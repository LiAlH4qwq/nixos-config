{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./fs
    ./fprint
  ];

  liuxu = {
    system = {
      bluetooth.enable = true;
      brightness.enable = true;
      fprint.enable = true;
      laptop.enable = true;
      podman.enable = true;
      secureboot.enable = true;
      virtualbox.enable = true;
    };
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
}

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
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

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

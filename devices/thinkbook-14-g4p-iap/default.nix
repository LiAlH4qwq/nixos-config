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
}

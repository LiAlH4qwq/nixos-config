{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hw
  ];

  liuxu.system.laptop.enable = true;

  networking.hostName = "LiAlH4-Laptop-Nix";

  time.timeZone = "Asia/Shanghai";

  environment.systemPackages = with pkgs; [
    sbctl
    brightnessctl
  ];
}

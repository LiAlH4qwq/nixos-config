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

  networking.hostName = "LiAlH4-Laptop-Nix";

  time.timeZone = "Asia/Shanghai";

  environment.systemPackages = with pkgs; [
    sbctl
    brightnessctl
  ];
}

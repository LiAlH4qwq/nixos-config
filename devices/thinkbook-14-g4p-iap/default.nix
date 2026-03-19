{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hw
    ];

  networking.hostName = "LiAlH4-Laptop-Nix";

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    sbctl
    brightnessctl
  ];

  # Reflects NixOS version when system installed.
  # Do not change it unless needed.
  system.stateVersion = "25.11";
}


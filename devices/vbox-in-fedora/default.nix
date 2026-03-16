{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hw.nix
    ];

  networking.hostName = "LiAlH4-Nix";

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh.enable = true;

  # To make distro bundled auto-completion rules work.
  programs.fish.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Reflects NixOS version when system installed.
  # Do not change it unless needed.
  system.stateVersion = "25.11";
}


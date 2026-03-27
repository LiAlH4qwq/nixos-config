{ pkgs, ... }:
{
  # It hasn't been available as a program till NixOS 25.11.
  environment.systemPackages = with pkgs; [
    eza
  ];
  programs.fish.shellAliases.ls = "eza --color --icons --git";
}

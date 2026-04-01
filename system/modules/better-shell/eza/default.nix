{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.liuxu.system.better-shell.enable {
    # It hasn't been available as a program till NixOS 25.11.
    environment.systemPackages = with pkgs; [
      eza
    ];
    programs.fish.shellAliases = {
      eza = "eza --color --icons --git";
      ls = "eza";
    };
  };
}

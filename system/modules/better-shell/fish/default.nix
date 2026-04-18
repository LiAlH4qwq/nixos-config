{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.liuxu.system.better-shell.enable {
    programs.fish = {
      enable = true;
      shellInit = ''
        set fish_greeting
      '';
    };
    users.defaultUserShell = pkgs.fish;
  };
}

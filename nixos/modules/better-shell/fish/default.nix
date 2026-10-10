{
  config,
  lib,
  pkgs,
  ...
}:
{
  here = { };
  config = lib.mkIf config.liuxu.nixos.better-shell.enable {
    programs.fish = {
      enable = true;
      shellInit = ''
        set fish_greeting
      '';
    };
    users.defaultUserShell = pkgs.fish;
  };
}

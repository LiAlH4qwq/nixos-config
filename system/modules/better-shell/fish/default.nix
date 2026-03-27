{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.liuxu.system.better-shell.enable {
    programs.fish = {
      enable = true;
    };
    users.defaultUserShell = pkgs.fish;
  };
}

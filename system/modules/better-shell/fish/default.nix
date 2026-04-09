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
      shellAliases = {
        rebuild = "run0 nixos-rebuild switch -F ${inputs.self}";
      };
    };
    users.defaultUserShell = pkgs.fish;
  };
}

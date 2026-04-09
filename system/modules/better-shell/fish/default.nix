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
      shellAbbrs = {
        rebuild = "run0 nixos-rebuild switch --flake /mnt/data/lialh4/Projects/nixos-config#thinkbook-14-g4p-iap";
      };
    };
    users.defaultUserShell = pkgs.fish;
  };
}

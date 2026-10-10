{ config, lib, ... }:
{
  here = { };
  config = lib.mkIf config.liuxu.nixos.better-shell.enable {
    programs = {
      bat = {
        enable = true;
      };
      fish.shellAliases.cat = "bat";
      bash.shellAliases.cat = "bat";
    };
  };
}

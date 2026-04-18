{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.system.better-shell.enable {
    programs = {
      bat = {
        enable = true;
      };
      fish.shellAliases.cat = "bat";
      bash.shellAliases.cat = "bat";     
    };
  };
}

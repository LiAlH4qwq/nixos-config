{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.system.better-shell.enable {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}

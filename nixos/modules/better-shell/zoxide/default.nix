{ config, lib, ... }:
{
  here = { };
  config = lib.mkIf config.liuxu.nixos.better-shell.enable {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };
  };
}

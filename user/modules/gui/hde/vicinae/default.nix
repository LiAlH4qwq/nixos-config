{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.user.gui.enable {
    programs.vicinae = {
      enable = false;
      systemd = {
        enable = true;
        autoStart = true;
      };
      settings = {
        font = {
          size = 12;
        };
        theme = {
          name = "rose-pine-dawn";
        };
      };
    };
  };
}

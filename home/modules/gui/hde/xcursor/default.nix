{
  config,
  lib,
  pkgs,
  ...
}:
{
  here = { };
  config = lib.mkIf config.liuxu.home.internal.final.gui.enable {
    home.pointerCursor = {
      enable = true;
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePineDawn-Linux";
      gtk.enable = true;
      x11.enable = true;
      hyprcursor.enable = true;
    };
  };
}

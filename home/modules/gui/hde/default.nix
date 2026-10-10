{
  config,
  lib,
  pkgs,
  ...
}:
{
  here = { };
  config = lib.mkIf config.liuxu.home.internal.final.gui.enable {
    home.packages = with pkgs; [
      wl-clipboard-rs # Clipboard
    ];
  };
}

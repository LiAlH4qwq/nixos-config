{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.user.gui.enable {
    programs.hyprshot = {
      enable = true;
      saveLocation = "$HOME/Pictures/Screenshots";
    };
  };
}

{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.home.gui.enable {
    wayland.windowManager.hyprland.settings.execr-once = [
      "fcitx5 -rd"
    ];
  };
}

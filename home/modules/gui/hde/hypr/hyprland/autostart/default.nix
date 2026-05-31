{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.home.gui.enable {
    wayland.windowManager.hyprland.settings.execr-once = [
      "systemctl --user start xdg-autostart-if-no-desktop-manager.target"
    ];
  };
}

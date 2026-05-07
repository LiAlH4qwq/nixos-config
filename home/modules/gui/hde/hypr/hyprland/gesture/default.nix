{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.home.gui.enable {
    wayland.windowManager.hyprland.settings = {
      gesture = [
        "3, down, dispatcher, execr, uwsm-app -- hyprshot -o $HOME/Pictures/Screenshots -zm output -m active"
      ];
    };
  };
}

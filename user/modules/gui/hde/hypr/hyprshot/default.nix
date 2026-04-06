{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.user.gui.enable {
    programs.hyprshot.enable = true;
    wayland.windowManager.hyprland.settings.bind =
      let
        cmd = "uwsm-app -- hyprshot -o ${loc}";
        loc = "$HOME/Pictures/Screenshots -zm";
      in
      [
        # Screenshot keys on Thinkbook 14 G4+ IAP.
        # Screenshot key of this device is hardcoded to Win + Shift + S.
        # Fn + Screenshot key is Screen/Sysrq
        # Screenshot key.
        "SUPER SHIFT, S, execr, ${cmd} region"
        # Fn + Screenshot key.
        ", Print, execr, ${cmd} window"
        # Fn + Ctrl + Screenshot key.
        "CTRL, Print, execr, ${cmd} output"
      ];
  };
}

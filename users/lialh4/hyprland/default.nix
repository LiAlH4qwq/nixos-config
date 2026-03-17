_: {
  home-manager.users.lialh4.wayland.windowManager.hyprland.settings = {
    "$terminal" = "foot";
    "$browser" = "firefox";
    "$mainMod" = "SUPER";
    monitor = [
      ", preferred, auto, 2"
    ];
    bind = [
      "$mainMod, Delete, exec, uwsm stop"
      "$mainMod, Q, killactive"
      "$mainMod, T, exec, uwsm-app -- $terminal"
      "$mainMod, B, exec, uwsm-app -- $browser"
    ];
  };
}
_: {
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "kitty";
    "$browser" = "firefox";
    "$mainMod" = "SUPER";
    bind = [
      "$mainMod, Delete, uwsm stop"
      "$mainMod, Q, killactive"
      "$mainMod, T exec, uwsm app -- $terminal"
      "$mainMod, B, exec, uwsm app -- $browser"
    ];
  };
}
{
  "$im" = "fcitx5";
  "$statusbar" = "ashell";
  "$launcher" = "hyprlauncher";
  "$terminal" = "kitty";
  "$browser" = "firefox";
  "$pwd" = "1password";
  "$mainMod" = "SUPER";
  execr-once = [
    "uwsm-app -s s -u $im -- $im"
    "uwsm-app -s s -u $statusbar -- $statusbar"
    "uwsm-app -s b -u $pwd -- $pwd"
  ];
  monitor = [
    ", preferred, auto, 2"
  ];
  input.natural_scroll = true;
  input.touchpad.natural_scroll = true;
  bind = [
    "$mainMod, Delete, execr, uwsm stop"
    "$mainMod, Q, killactive"
    "$mainMod, R, execr, uwsm-app -- $launcher"
    "$mainMod, T, execr, uwsm-app -- $terminal"
    "$mainMod, B, execr, uwsm-app -- $browser"
  ] ++ (
    builtins.concatLists (
      builtins.genList (
        i:
          let
            ws = i + 1;
          in [
            "$mainMod, code:1${toString i}, workspace, ${toString ws}"
            "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
      )
      9
    )
  );
}
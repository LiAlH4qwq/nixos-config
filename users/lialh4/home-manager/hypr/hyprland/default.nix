{ lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    # Due to conflict with home-manager
    systemd.enable = false;
    settings = {
      "$statusbar" = "ashell";
      "$launcher" = "vicinae toggle";
      "$clipboard" = "vicinae vicinae://extensions/vicinae/clipboard/history";
      "$terminal" = "kitty";
      "$explorer" = "nautilus -w";
      "$browser" = "firefox";
      "$pwd" = "1password";
      "$mainMod" = "SUPER";
      exec-once = [
        "uwsm-app -t service -s s -u $statusbar.service -- $statusbar"
        "[workspace name:Password silent] uwsm-app -t service -s b -u $pwd.service -- $pwd"
      ];
      general = {
        border_size = 4;
        # Look like double? Actually they are same!
        gaps_in = 0;
        gaps_out = 0;
        "col.active_border" = "0xffd7827e";
        "col.inactive_border" = "0xff9893a5";
      };
      monitor = [
        ", preferred, auto, 2"
      ];
      input.natural_scroll = true;
      input.touchpad.natural_scroll = true;
      bind = [
        "$mainMod, Delete, execr, loginctl kill-session $XDG_SESSION_ID"
        "$mainMod, Q, killactive"
        "$mainMod SHIFT, Q, forcekillactive"
        "$mainMod, R, execr, uwsm-app -- $launcher"
        "$mainMod, V, execr, uwsm-app -- $clipboard"
        "$mainMod, T, execr, uwsm-app -- $terminal"
        "$mainMod, E, execr, uwsm-app -- $explorer"
        "$mainMod, B, execr, uwsm-app -- $browser"
        "$mainMod ALT, Tab, workspace, empty"
        "$mainMod ALT SHIFT, Tab, movetoworkspace, empty"
        # Screenshot keys on Thinkbook 14 G4+ IAP.
        # Screenshot key of this device is hardcoded to Win + Shift + S.
        # Screenshot key.
        "$mainMod SHIFT, S, execr, uwsm-app -- hyprshot -zm region"
        # Fn + Screenshot key.
        ", Print, execr, uwsm-app -- hyprshot -zm window"
        # Fn + Ctrl + Screenshot key.
        "CTRL, Print, execr, uwsm-app -- hyprshot -zm output"
        ", XF86Favorites, workspace, name:Password"
        "SHIFT, XF86Favorites, movetoworkspace, name:Password"
      ]

      ++ (lib.concatMap (
        k:
        let
          ks = toString k;
          w = if k == 0 then 10 else k;
          ws = toString w;
        in
        [
          "$mainMod, ${ks}, workspace, ${ws}"
          "$mainMod SHIFT, ${ks}, movetoworkspace, ${ws}"
        ]
      ) (lib.range 0 9));
      bindl = [
        ", XF86AudioMute, execr, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, execr, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
      binde = [
        "$mainMod, Tab, workspace, +1"
        "$mainMod SHIFT, Tab, workspace, -1"
      ];
      bindle = [
        ", XF86AudioRaiseVolume, execr, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, execr, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, execr, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, execr, brightnessctl set 5%-"
      ];
    };
  };
}

{ lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    # Due to conflict with home-manager
    systemd.enable = false;
    settings =
      let
        mod = "SUPER";
        startService = target: "uwsm-app -s s -t service -u uwsm-service-${target}.service -- ${target}";
        startBg = target: "uwsm-app -s b -t service -u uwsm-bg-${target}.service -- ${target}";
        statusbar = "ashell";
        launcher = "vicinae toggle";
        clipboard = "vicinae vicinae://extensions/vicinae/clipboard/history";
        terminal = "kitty";
        explorer = "nautilus -w";
        taskmgr = "missioncenter";
        browser = "firefox";
        pwd = "1password";
      in
      {
        misc = {
          # Fallback to anime wallpaper when hyprpaper fails.
          force_default_wallpaper = 2;
        };
        general = {
          border_size = 4;
          gaps_in = 0;
          gaps_out = 0;
          "col.active_border" = "0xffd7827e";
          "col.inactive_border" = "0xff9893a5";
        };
        input = {
          natural_scroll = true;
          touchpad.natural_scroll = true;
        };
        monitor = [
          ", preferred, auto, 2"
        ];
        exec-once = [
          (startService statusbar)
          (startBg pwd)
        ];
        bind = [
          "${mod}, Delete, execr, loginctl kill-session $XDG_SESSION_ID"
          "${mod}, Q, killactive"
          "${mod} SHIFT, Q, forcekillactive"
          "${mod}, F, togglefloating"
          "${mod}, L, execr, ${startBg "hyprlock"}"
          "${mod}, R, execr, uwsm-app -- ${launcher}"
          "${mod}, V, execr, uwsm-app -- ${clipboard}"
          "${mod}, T, execr, uwsm-app -- ${terminal}"
          "${mod}, E, execr, uwsm-app -- ${explorer}"
          "${mod}, Escape, execr, uwsm-app -- ${taskmgr}"
          "${mod}, B, execr, uwsm-app -- ${browser}"
          "${mod} SHIFT, Tab, execr, hyprnome -mc"
          "${mod} ALT SHIFT, Tab, execr, hyprnome -mcp"
          "${mod}, grave, workspace, empty"
          "${mod} SHIFT, grave, movetoworkspace, empty"
          # Screenshot keys on Thinkbook 14 G4+ IAP.
          # Screenshot key of this device is hardcoded to Win + Shift + S.
          # Fn + Screenshot key is Screen/Sysrq
          # Screenshot key.
          "SUPER SHIFT, S, execr, uwsm-app -- hyprshot -zm region"
          # Fn + Screenshot key.
          ", Print, execr, uwsm-app -- hyprshot -zm window"
          # Fn + Ctrl + Screenshot key.
          "CTRL, Print, execr, uwsm-app -- hyprshot -zm output"
          "${mod}, XF86Favorites, workspace, name:Password"
          "${mod} SHIFT, XF86Favorites, movetoworkspace, name:Password"
        ]

        ++ (lib.concatMap (
          k:
          let
            ks = toString k;
            w = if k == 0 then 10 else k;
            ws = toString w;
          in
          [
            "${mod}, ${ks}, workspace, ${ws}"
            "${mod} SHIFT, ${ks}, movetoworkspace, ${ws}"
          ]
        ) (lib.range 0 9));
        bindl = [
          ", XF86AudioMute, execr, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, execr, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ];
        binde = [
          "${mod}, Tab, execr, hyprnome -c"
          "${mod} ALT, Tab, execr, hyprnome -cp"
        ];
        bindle = [
          ", XF86AudioRaiseVolume, execr, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, execr, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86MonBrightnessUp, execr, brightnessctl set 5%+"
          ", XF86MonBrightnessDown, execr, brightnessctl set 5%-"
        ];
        bindm = [
          "${mod}, mouse:272, movewindow"
        ];
      };
  };
}

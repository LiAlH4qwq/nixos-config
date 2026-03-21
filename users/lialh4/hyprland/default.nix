{ lib, ... }:
{
  home-manager.users.lialh4.wayland.windowManager.hyprland = {
    enable = true;
    # Due to conflict with home-manager
    systemd.enable = false;
    settings = {
      "$statusbar" = "ashell";
      "$launcher" = "vicinae toggle";
      "$terminal" = "kitty";
      "$explorer" = "nautilus";
      "$browser" = "firefox";
      "$pwd" = "1password";
      "$mainMod" = "SUPER";
      exec-once = [
        "uwsm-app -t service -s s -u $statusbar.service -- $statusbar"
        "[ws name:Password silent] uwsm-app -t service -s b -u $pwd.service -- $pwd"
      ];
      general = {
        border_size = 5;
        # Look like double? Actually they are same!
        gaps_in = 5;
        gaps_out = 10;
        "col.active_border" = "0xffd7827e";
        "col.inactive_border" = "0xff9893a5";
      };
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
        "$mainMod, E, execr, uwsm-app -- $explorer"
        "$mainMod, B, execr, uwsm-app -- $browser"
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
      bindle = [
        ", XF86AudioRaiseVolume, execr, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, execr, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, execr, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, execr, brightnessctl set 5%-"
      ];
    };
  };
}

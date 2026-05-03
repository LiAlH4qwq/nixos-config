{ config, lib, ... }:
{
  imports = [
    ./noctalia
    ./wrule
  ];

  config = lib.mkIf config.liuxu.user.gui.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      # Due to conflict with home-manager
      systemd.enable = false;
      settings =
        let
          mod = "SUPER";
          startBg = target: "uwsm-app -s b -t service -u uwsm-bg-${target}.service -- ${target}";
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
            (startBg pwd)
          ];
          bind = [
            "${mod}, Delete, execr, loginctl kill-session $XDG_SESSION_ID"
            "${mod}, Q, killactive"
            "${mod} SHIFT, Q, forcekillactive"
            "${mod}, F, togglefloating"
            "${mod}, T, execr, uwsm-app -- ${terminal}"
            "${mod}, E, execr, uwsm-app -- ${explorer}"
            "${mod}, Escape, execr, uwsm-app -- ${taskmgr}"
            "${mod}, B, execr, uwsm-app -- ${browser}"
            "${mod} SHIFT, Tab, execr, hyprnome -mc"
            "${mod} ALT SHIFT, Tab, execr, hyprnome -mcp"
            "${mod}, grave, workspace, empty"
            "${mod} SHIFT, grave, movetoworkspace, empty"
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
          binde = [
            "${mod}, Tab, execr, hyprnome -c"
            "${mod} ALT, Tab, execr, hyprnome -cp"
          ];
          bindm = [
            "${mod}, mouse:272, movewindow"
            "${mod} ALT, mouse:272, resizewindow 1" # Keep aspect ratio
            "${mod} ALT SHIFT, mouse:272, resizewindow 2" # Ignore aspect ratio
          ];
        };
    };
  };
}

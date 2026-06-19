{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
    ./bar
    ./power
  ];

  config = lib.mkIf config.liuxu.home.gui.enable {
    programs.noctalia = {
      enable = true;
      settings = {
        weather.enabled = false;
        osd.position = "bottom_center";
        shell = {
          polkit_agent = true;
          telemetry_enabled = true;
          screen_time_enabled = true;
          settings_show_advanced = true;
          avatar_path = "~/Pictures/Avatar.jpg";
          screenshot = {
            directory = "~/Pictures/Screenshots";
          };
        };
        theme = {
          builtin = "Rosé Pine";
          mode = "auto";
        };
        wallpaper =
          let
            dir = "/etc/wallpapers";
            file = "${dir}/rainy-everything-in-the-night.png";
          in
          {
            directory = dir;
            default.path = file;
          };
        control_center.shortcuts = map (e: { type = e; }) [
          "wifi"
          "bluetooth"
          "notification" # DND
          "caffeine"
          "dark_mode"
          "power_profile"
        ];
      };
    };
    liuxu.home.internal.intransience = {
      dirs = [
        # Keep it to supress the welcome dialog.
        ".local/state/noctalia/community-palettes"
      ];
      files = [ ".local/state/noctalia/screen_time.json" ];
    };
  };
}

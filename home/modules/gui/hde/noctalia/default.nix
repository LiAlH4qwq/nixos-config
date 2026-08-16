{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
    ./bar
    ./lockscreen
    ./power
  ];

  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    programs.noctalia = {
      enable = true;
      package = pkgs.unstable.noctalia;
      settings = {
        weather.enabled = false;
        osd.position = "bottom_center";
        shell = {
          polkit_agent = true;
          telemetry_enabled = true;
          screen_time_enabled = true;
          settings_show_advanced = true;
          avatar_path = "${self}/assets/lialh4.jpg";
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
            dir = "~/Pictures/Wallpapers";
            file = "${dir}/rainy-everything-in-the-night.png";
          in
          {
            directory = dir;
            default.path = file;
            last.path = file;
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
    home.file.wallpaper = {
      target = "Pictures/Wallpapers/rainy-everything-in-the-night.png";
      source = "${self}/assets/rainy-everything-in-the-night.png";
    };
    liuxu.home.internal.intransience = {
      dirs = [ ".local/state/noctalia/clipboard" ];
      files = [
        ".local/state/noctalia/notification_history.json"
        ".local/state/noctalia/recently_used.json"
        ".local/state/noctalia/screen_time.json"
        ".local/state/noctalia/usage_counts.json"
      ];
    };
    systemd.user.tmpfiles.rules = [ "f %h/.local/state/noctalia/.setup-complete - - - - -" ];
  };
}

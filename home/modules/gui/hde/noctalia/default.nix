{
  config,
  inputs,
  lib,
  pkgs,
  root,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf config.liuxu.home.internal.final.gui.enable {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      package = pkgs.unstable.noctalia;
      settings = {
        weather.enabled = false;
        osd.position = "bottom_center";
        shell = {
          polkit_agent = true;
          telemetry_enabled = true;
          screen_time_enabled = true;
          settings_show_advanced = true;
          launch_apps_as_systemd_services = true;
          screenshot = {
            directory = "~/Pictures/Screenshots";
          };
        }
        // lib.optionalAttrs (config.liuxu.home.id != null) { avatar_path = config.liuxu.home.id.avatar; };
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
    systemd.user.services.noctalia = {
      Unit = {
        PartOf = [
          "pipewire.service"
          "wireplumber.service"
        ];
        After = [
          "pipewire.service"
          "wireplumber.service"
        ];
      };
      Service.ExecStartPre = [
        (
          lib.getExe
          <|
            pkgs.writers.writeNuBin "noctalia-wait-networkmanager"
              {
                makeWrapperArgs = [
                  "--prefix"
                  "PATH"
                  ":"
                  (lib.makeBinPath [
                    pkgs.systemd
                    pkgs.uutils-coreutils-noprefix
                  ])
                ];
              }
              ''
                for _ in 0..149 {
                  if (^busctl --system status org.freedesktop.NetworkManager | complete | get exit_code) == 0 {
                    exit 0
                  }
                  sleep 200ms
                }
                print -e "NetworkManager not on the system bus after 30s; starting noctalia anyway"
              ''
        )
      ];
    };
    home.file.wallpaper = {
      target = "Pictures/Wallpapers/rainy-everything-in-the-night.png";
      source = "${root}/assets/rainy-everything-in-the-night.png";
    };
    liuxu.home.preservation = {
      directories = [ ".local/state/noctalia/clipboard" ];
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

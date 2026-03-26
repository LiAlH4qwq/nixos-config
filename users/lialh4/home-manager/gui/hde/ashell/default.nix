# Rose Pine Dawn Theme
# Source: https://rosepinetheme.com/palette/
# Relation: Hyprtoolkit color <--> Rose Pine Dawn color
# text <--> Text
# background.base <--> Base
# background.weak <--> Surface
# background.strong <--> Overlay
# primary <--> Rose
# secondary <--> Love

_: {
  programs.ashell = {
    enable = true;
    settings = {
      appearance = {
        scale_factor = 1.1;
        style = "Solid";
        text_color = "#575279";
        primary_color = "#d7827e";
        secondary_color = "#b4637a";
        background_color = {
          base = "#faf4ed";
          strong = "#f2e9e1";
          weak = "#fffaf3";
        };
      };
      modules = {
        left = [
          "SystemInfo"
          "Workspaces"
          "WindowTitle"
        ];
        center = [
          "Clock"
        ];
        right = [
          "MediaPlayer"
          "Tray"
          "Settings"
        ];
      };
      system_info = {
        indicators = [
          "Cpu"
          "Memory"
          "Temperature"
        ];
      };
      window_title = {
        truncate_title_after_length = 42;
      };
      settings = {
        shutdown_cmd = "poweroff";
        suspend_cmd = "systemctl suspend-then-hibernate";
        hibernate_cmd = "systemctl hibernate";
        reboot_cmd = "reboot";
        logout_cmd = "loginctl kill-session $XDG_SESSION_ID";
        vpn_more_cmd = "clash-verge";
        peripheral_battery_format = "IconAndPercentage";
        indicators = [
          "IdleInhibitor"
          "Bluetooth"
          "Vpn"
          "Network"
          "Audio"
          "PowerProfile"
          "Battery"
        ];
      };
    };
  };
}

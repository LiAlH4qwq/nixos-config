# Rose Pine Dawn Theme
# Source: https://rosepinetheme.com/palette/

{ config, lib, ... }:
{
  config = lib.mkIf config.liuxu.user.gui.enable {
    programs.ashell = {
      enable = true;
      settings = {
        enable_esc_key = true;
        appearance =
          let
            cl_text = "#575279";
            cl_base = "#faf4ed";
            cl_surface = "#fffaf3";
            cl_overlay = "#f2e9e1";
            cl_rose = "#d7827e";
            cl_love = "#b4637a";
          in
          {
            scale_factor = 1.2;
            style = "Solid";
            text_color = {
              base = cl_text;
              strong = cl_text;
              weak = cl_text;
              text = cl_text;
            };
            background_color = {
              base = cl_base;
              strong = cl_overlay;
              weak = cl_surface;
              text = cl_text;
            };
            primary_color = {
              base = cl_rose;
              strong = cl_rose;
              weak = cl_rose;
              text = cl_text;
            };
            secondary_color = {
              base = cl_love;
              strong = cl_love;
              weak = cl_love;
              text = cl_text;
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
  };
}

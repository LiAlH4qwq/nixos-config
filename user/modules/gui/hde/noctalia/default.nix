{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.noctalia.homeModules.default ];

  config = lib.mkIf config.liuxu.user.gui.enable {
    programs.noctalia-shell = {
      enable = true;
      settings = {
        settingsVersion = 0;
        general = {
          telemetryEnabled = true;
          showChangelogOnStartup = false;
          avatarImage = "~/Pictures/Avatar.jpg";
          # UI
          enableShadows = false;
          # Lockscreen
          autoStartAuth = true;
          allowPasswordWithFprintd = true;
        };
        location = {
          name = "Zhengzhou, China";
        };
        ui = {
          boxBorderEnabled = true;
        };
        colorSchemes = {
          darkMode = false;
          predefinedScheme = "Rose Pine";
        };
        wallpaper = {
          directory = "/etc/wallpapers";
        };
        idle = {
          enabled = true;
          screenOffTimeout = 5 * 60; # s
          lockTimeout = 5 * 60 + 1 * 60; # s
          suspendTimeout = 15 * 60; # s
        };
        sessionMenu = {
          largeButtonsLayout = "grid";
        };
        appLauncher = {
          density = "comfortable";
          enableClipboardHistory = true;
          customLaunchPrefixEnabled = true;
          customLaunchPrefix = "uwsm-app --";
          terminalCommand = "kitty -e";
        };
        osd = {
          location = "bottom_center";
          enabledTypes = [
            0
            1
            2
            3
          ];
        };
        dock = {
          size = 1.5;
          groupApps = true;
          groupClickAction = "list";
          showLauncherIcon = true;
          launcherUseDistroLogo = true;
          launcherPosition = "start";
        };
        bar = {
          showCapsule = false;
          outerCorners = false;
          density = "comfortable";
          fontScale = 1.2;
          widgets = {
            left = [
              {
                id = "SystemMonitor";
              }
              {
                id = "Workspace";
                pillSize = 0.67;
              }
              {
                id = "ActiveWindow";
                maxWidth = 456;
              }
            ];
            center = [
              {
                id = "Clock";
              }
            ];
            right = [
              {
                id = "MediaMini";
              }
              {
                id = "Tray";
              }
              {
                id = "NotificationHistory";
              }
              {
                id = "Volume";
              }
              {
                id = "Brightness";
              }
              {
                id = "Battery";
              }
              {
                id = "ControlCenter";
              }
            ];
          };
        };
      };
    };
  };
}

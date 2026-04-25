{ inputs, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
    settings = {
      settingsVersion = 0;
      bar = {
        showCapsule = false;
        outerCorners = false;
        widgets = {
          left = [
            {
              id = "SystemMonitor";
            }
            {
              id = "Workspace";
            }
            {
              id = "ActiveWindow";
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
      colorSchemes = {
        darkMode = false;
      };
    };
  };
}

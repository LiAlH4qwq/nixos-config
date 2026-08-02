{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    programs.noctalia.settings.lockscreen_widgets =
      let
        widget =
          let
            clockAttrs = {
              type = "clock";
              settings = {
                background = false;
                shadow = false;
                color = "#FFFFFF";
              };
            };
          in
          {
            login-box = {
              type = "login_box";
              box_width = 400.0;
              box_height = 103.0;
              cx = 823.0;
              cy = 854.0;
              settings = {
                layout = "compact";
                center_password_text = true;
                background_opacity = 0.0;
                input_opacity = 0.0;
                input_radius = 32.0;
              };
            };
            time = lib.recursiveUpdate clockAttrs {
              box_width = 320.0;
              box_height = 160.0;
              cx = 823.0;
              cy = 274.5;
              settings.format = "%H:%M";
            };
            date = lib.recursiveUpdate clockAttrs {
              box_width = 160.0;
              box_height = 32.0;
              cx = 823.0;
              cy = 210.5;
              settings.format = "%a, %b %e";
            };
          };
      in
      {
        inherit widget;
        enabled = true;
        grid = {
          visible = true;
          cell_size = 32;
          major_interval = 4;
        };
        widgets_order = builtins.attrNames widget;
      };
  };
}

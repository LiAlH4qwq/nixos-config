{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.gui.niri.enable {
    wayland.windowManager.niri.settings.window-rule = [
      {
        open-maximized = true;
        open-fullscreen = false;
      }
      {
        match = [
          {
            _props = {
              app-id = "steam_proton";
            };
          }
          {
            _props = {
              title = "崩坏：星穹铁道";
            };
          }
        ];
        #_children = [
        #  {
        #    match._props = {
        #      app-id = "steam_proton";
        #    };
        #  }
        #  {
        #    match._props = {
        #      title = "崩坏：星穹铁道";
        #    };
        #  }
        #];
        open-fullscreen = true;
      }
    ];
  };
}

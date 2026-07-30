{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.liuxu.home.gui.niri.enable {
    liuxu.home.gui.niri.settings = lib.mkAfter (
      lib.kdl.formats.v1 (
        with lib.kdl.extras.niri;
        [
          (include (
            lib.liuxu.oo toString pkgs.writeText "niri-window-rule.kdl" (
              lib.kdl.formats.v1 [
                (window-rule [
                  (match { app-id = "steam_proton"; })
                  (match { title = "崩坏：星穹铁道"; })
                  (open-fullscreen true)
                ])
              ]
            )
          ))
        ]
      )
    );
  };
}

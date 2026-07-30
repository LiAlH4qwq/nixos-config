{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.home.internal.gui = {
    autostart = lib.mkOption {
      internal = true;
      type = with lib.types; listOf (coercedTo str lib.singleton (listOf str));
      default = [ ];
    };
    autostartInKdl = lib.mkOption {
      internal = true;
      readOnly = true;
      default =
        config.liuxu.home.internal.gui.autostart
        |> lib.liuxu.oo map builtins.foldl' lib.id lib.kdl.extras.niri.spawn-at-startup
        |> lib.kdl.formats.v1;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.liuxu.home.internal.gui.enable {
      liuxu.home.internal.gui.autostart = [
        # Fix fcitx5 won't work.
        [
          "fcitx5"
          "-rd"
        ]
        [
          "1password"
          "--silent"
        ]
      ];
    })
    (
      let
        cfg = config.liuxu.home.internal.gui.autostart;
      in
      lib.mkIf (cfg != [ ]) (
        lib.mkMerge [
          (lib.mkIf config.liuxu.home.gui.hyprland.enable {
            wayland.windowManager = {
              hyprland.settings.on =
                cfg
                |> map (builtins.concatStringsSep " ")
                |> map (e: {
                  _args = [
                    "hyprland.start"
                    (lib.generators.mkLuaInline ''
                      function()
                        hl.exec_cmd("${e}")
                      end
                    '')
                  ];
                });
            };
          })
          (lib.mkIf config.liuxu.home.gui.niri.enable {
            liuxu.home.gui.niri.settings = lib.mkAfter (
              lib.kdl.formats.v1 (
                lib.singleton (
                  lib.kdl.extras.niri.include (
                    lib.liuxu.oo toString pkgs.writeText "niri-autostart-from-common.kdl"
                      config.liuxu.home.internal.gui.autostartInKdl
                  )
                )
              )
            );
          })
        ]
      )
    )
  ];
}

{ config, lib, ... }:
{
  options.liuxu.home.internal.gui.autostart = lib.mkOption {
    internal = true;
    type = with lib.types; listOf (coercedTo str lib.singleton (listOf str));
    default = [ ];
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
            wayland.windowManager.niri.settings.spawn-at-startup = cfg;
          })
        ]
      )
    )
  ];
}

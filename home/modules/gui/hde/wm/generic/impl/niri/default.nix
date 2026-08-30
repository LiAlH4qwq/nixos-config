{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.liuxu.home.gui.niri.enable (
    lib.mkMerge [
      (
        let
          cfg = config.liuxu.home.gui.autostart;
        in
        (lib.mkIf (cfg != [ ]) {
          liuxu.home.gui.niri.settings =
            cfg
            |> map (builtins.foldl' lib.id lib.kdl.extras.niri.spawn-at-startup)
            |> lib.kdl.formats.v1
            |> pkgs.writeText "niri-autostart-from-common.kdl"
            |> toString
            |> lib.kdl.extras.niri.include
            |> lib.singleton
            |> lib.kdl.formats.v1
            |> lib.mkAfter;
        })
      )
      (
        let
          cfg = config.liuxu.home.gui.keybinds.generic;
        in
        (lib.mkIf (cfg != [ ]) {
          liuxu.home.gui.niri.settings =
            cfg
            |> map (
              e:
              lib.kdl.extras.niri.n
                "${if e.mod == [ ] then "" else "${e.mod |> builtins.concatStringsSep "+"}+"}${e.key}"
                {
                  inherit (e.opt) repeat;
                  allow-when-locked = e.opt.lock;
                }
                (
                  with lib.kdl.extras.niri;
                  (
                    if e.type == "close-window" then
                      close-window
                    else if e.type == "execr" then
                      builtins.foldl' lib.id spawn e.args
                    else if e.type == "focus-workspace" then
                      focus-workspace e.args
                    else
                      throw "Unreachable"
                  )
                  |> lib.singleton
                )
            )
            |> lib.kdl.extras.niri.binds
            |> lib.singleton
            |> lib.kdl.formats.v1
            |> pkgs.writeText "niri-keybinds-from-common.kdl"
            |> toString
            |> lib.kdl.extras.niri.include
            |> lib.singleton
            |> lib.kdl.formats.v1
            |> lib.mkAfter;
        })
      )
    ]
  );
}

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
          cfg = config.liuxu.home.gui.wm.autostart;
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
          cfg = config.liuxu.home.internal.gui.wm.keybinds;
          action = with lib.kdl.extras.niri; {
            window-close = _: close-window;
            execr = e: builtins.foldl' lib.id spawn e.args.cmd;
            workspace-focus = e: focus-workspace e.args.id;
            window-move-to-workspace = e: move-window-to-workspace e.args.id;
          };
          bind =
            e:
            lib.kdl.extras.niri.n
              "${if e.mod == [ ] then "" else "${e.mod |> builtins.concatStringsSep "+"}+"}${e.key}"
              (
                {
                  inherit (e.opts) repeat;
                }
                // (
                  if e.type != "execr" then
                    { }
                  else
                    {
                      allow-when-locked = e.opts.lock;
                    }
                )
              )
              (lib.singleton (action.${e.type} e));
        in
        (lib.mkIf (cfg != [ ]) {
          liuxu.home.gui.niri.settings =
            cfg
            |> map bind
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

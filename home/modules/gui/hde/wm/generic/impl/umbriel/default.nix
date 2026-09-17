{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.gui.umbriel.enable (
    lib.mkMerge [
      (
        let
          cfg = config.liuxu.home.gui.wm.autostart;
        in
        (lib.mkIf (cfg != [ ]) {
          programs.umbriel.settings.general.autostart = cfg |> map (builtins.concatStringsSep " ");
        })
      )
      (
        let
          cfg = config.liuxu.home.internal.gui.wm.keybinds;
          action = {
            window-close = _: "window-close";
            execr = e: "spawn:${e.args.cmd |> builtins.concatStringsSep " "}";
            workspace-focus = e: "workspace-switch:${toString e.args.id}";
            window-move-to-workspace = e: "window-move-to-workspace:${toString e.args.id}";
          };
        in
        (lib.mkIf (cfg != [ ]) {
          programs.umbriel.settings.keybinds =
            cfg
            |> map (e: {
              name = "${if e.mod == [ ] then "" else "${e.mod |> builtins.concatStringsSep "+"}+"}${e.key}";
              value = {
                inherit (e.opts) repeat;
                allow_when_locked = e.opts.lock;
                action = action.${e.type} e;
              };
            })
            |> builtins.listToAttrs;
        })
      )
    ]
  );
}

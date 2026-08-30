{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.gui.umbriel.enable (
    lib.mkMerge [
      (
        let
          cfg = config.liuxu.home.gui.autostart;
        in
        (lib.mkIf (cfg != [ ]) {
          programs.umbriel.settings.general.autostart = cfg |> map (builtins.concatStringsSep " ");
        })
      )
      (
        let
          cfg = config.liuxu.home.internal.gui.keybinds;
        in
        (lib.mkIf (cfg != [ ]) {
          programs.umbriel.settings.keybinds =
            cfg
            |> map (e: {
              name = "${if e.mod == [ ] then "" else "${e.mod |> builtins.concatStringsSep "+"}+"}${e.key}";
              value = {
                inherit (e.opt) repeat;
                allow_when_locked = e.opt.lock;
                action =
                  if e.type == "close-window" then
                    "window-close"
                  else if e.type == "execr" then
                    e.args.cmd |> builtins.concatStringsSep " " |> (x: "spawn:${x}")
                  else if e.type == "focus-workspace" then
                    "workspace-switch:${e.args.id}"
                  else if e.type == "move-window-to-workspace" then
                    "window-move-to-workspace:${e.args.id}"
                  else
                    throw "Unreachable";
              };
            })
            |> builtins.listToAttrs;
        })
      )
    ]
  );
}

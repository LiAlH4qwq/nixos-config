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
          cfg = config.liuxu.home.gui.keybinds.execr;
        in
        (lib.mkIf (cfg != [ ]) {
          programs.umbriel.settings.keybinds =
            cfg
            |> map (e: {
              name = "${if e.mod == [ ] then "" else "${e.mod |> builtins.concatStringsSep "+"}+"}${e.key}";
              value = e.cmd |> builtins.concatStringsSep " " |> (x: "spawn:${x}");
            })
            |> builtins.listToAttrs;
        })
      )
    ]
  );
}

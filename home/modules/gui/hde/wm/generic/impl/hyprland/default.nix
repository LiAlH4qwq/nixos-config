{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.gui.hyprland.enable (
    lib.mkMerge [
      (
        let
          cfg = config.liuxu.home.gui.wm.autostart;
        in
        (lib.mkIf (cfg != [ ]) {
          wayland.windowManager.hyprland.settings.on =
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
        })
      )
      (
        let
          cfg = config.liuxu.home.internal.gui.wm.keybinds;
          bind =
            e:
            let
              opts = {
                locked = e.opts.lock;
                repeating = e.opts.repeat;
              };
              mod = map (m: if m == "Mod" then "SUPER" else lib.toUpper m) e.mod;
              key = "${if mod == [ ] then "" else "${builtins.concatStringsSep "+" mod}+"}${e.key}";
              dispatch = {
                window-close =
                  if e.args.force then
                    lib.liuxu.hyprland.mkLuaBind opts "hl.dsp.window.kill()" key
                  else
                    lib.liuxu.hyprland.mkLuaBind opts "hl.dsp.window.close()" key;
                execr = lib.liuxu.hyprland.mkExecrBind opts (builtins.concatStringsSep " " e.args.cmd) key;
                workspace-focus =
                  lib.liuxu.hyprland.mkLuaBind opts ''hl.dsp.focus({workspace="${toString e.args.id}"})''
                    key;
                window-move-to-workspace =
                  lib.liuxu.hyprland.mkLuaBind opts ''hl.dsp.window.move({workspace="${toString e.args.id}"})''
                    key;
              };
            in
            dispatch.${e.type};
        in
        (lib.mkIf (cfg != [ ]) {
          wayland.windowManager.hyprland.settings.bind = map bind cfg;
        })
      )
    ]
  );
}

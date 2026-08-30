{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.gui.hyprland.enable (
    lib.mkMerge [
      (
        let
          cfg = config.liuxu.home.gui.autostart;
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
          cfg = config.liuxu.home.gui.keybinds.generic;
        in
        (lib.mkIf (cfg != [ ]) ({
          wayland.windowManager.hyprland.settings.bind =
            cfg
            |> map (
              e:
              let
                o = {
                  locked = e.opt.lock;
                  repeating = e.opt.repeat;
                };
                k = (
                  e
                  |> (e: e // { mod = map (m: if m == "Mod" then "SUPER" else lib.toUpper m) e.mod; })
                  |> (e: "${if e.mod == [ ] then "" else "${e.mod |> builtins.concatStringsSep "+"}+"}${e.key}")
                );
              in
              if e.type == "close-window" then
                (
                  if e.args.force then
                    lib.liuxu.hyprland.mkLuaBind o "hl.dsp.window.kill()" k
                  else
                    lib.liuxu.hyprland.mkLuaBind o "hl.dsp.window.close()" k
                )
              else if e.type == "execr" then
                lib.liuxu.hyprland.mkExecrBind o (builtins.concatStringsSep " " e.args) k
              else if e.type == "focus-workspace" then
                lib.liuxu.hyprland.mkLuaBind o ''hl.dsp.focus({workspace="${e.args}"})'' k
              else
                throw "Unreachable"
            );
        }))
      )
    ]
  );
}

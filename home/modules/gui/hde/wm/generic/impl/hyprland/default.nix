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
          cfg = config.liuxu.home.gui.keybinds.execr;
        in
        (lib.mkIf (cfg != [ ]) (
          let
            e2Hypr =
              let
                e2Mod2Super =
                  let
                    mod2Super = m: if m == "Mod" then "SUPER" else m;
                  in
                  e: e // { mod = map mod2Super e.mod; };
              in
              e:
              lib.liuxu.hyprland.mkExecrBind
                {
                  locked = e.opt.lock;
                  repeating = e.opt.repeat;
                }
                (builtins.concatStringsSep " " e.cmd)
                (
                  e
                  |> e2Mod2Super
                  |> (e: "${if e.mod == [ ] then "" else "${e.mod |> builtins.concatStringsSep "+"}+"}${e.key}")
                );
          in
          {
            wayland.windowManager.hyprland.settings.bind = map e2Hypr cfg;
          }
        ))
      )
    ]
  );
}

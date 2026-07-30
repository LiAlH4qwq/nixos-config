{
  config,
  lib,
  pkgs,
  ...
}:
let
  e2KeyExpr = e: if e.mod == [ ] then e.key else "${builtins.concatStringsSep "+" e.mod}+${e.key}";
in
{
  options.liuxu.home = {
    internal.gui.keybinds.execr.kdl = lib.mkOption {
      internal = true;
      readOnly = true;
      default =
        config.liuxu.home.gui.keybinds.execr
        |> map (
          e:
          lib.kdl.extras.niri.n (e2KeyExpr e) [
            (builtins.foldl' lib.id lib.kdl.extras.niri.spawn e.cmd)
          ]
        )
        |> lib.kdl.extras.niri.binds
        |> lib.singleton
        |> lib.kdl.formats.v1;
    };
    gui.keybinds.execr = lib.mkOption {
      default = [ ];
      example = [
        {
          mod = "Mod";
          key = "R";
          cmd = [
            "noctalia"
            "msg"
            "panel-toggle"
            "launcher"
          ];
          opt = {
            lock = false;
            repeat = false;
          };
        }
      ];
      description = ''
        Liuxu (Home): Keybinds that exec a cmd,
          apply to both Hyprland and Niri.
      '';
      type =
        with lib.types;
        listOf (submodule {
          options =
            let
              strOrListOfStr = coercedTo str lib.singleton (listOf str);
            in
            {
              mod = lib.mkOption {
                type = strOrListOfStr;
                default = [ ];
                example = "Mod";
                description = ''
                  Liuxu (Home): Keybind's modkey,
                    can be a single string or a list of string.
                '';
              };
              key = lib.mkOption {
                type = str;
                example = "R";
                description = ''
                  Liuxu (Home): Keybind's key,
                    must not be empty.
                '';
              };
              cmd = lib.mkOption {
                type = strOrListOfStr;
                example = [
                  "noctalia"
                  "msg"
                  "panel-toggle"
                  "launcher"
                ];
                description = ''
                  Liuxu (Home): Keybind's cmd to exec,
                    must not be empty,
                    can be a single str if there's no args.
                '';
              };
              opt = {
                lock = lib.mkOption {
                  type = bool;
                  default = false;
                  example = true;
                  description = ''
                    Liuxu (Home): Whether or not the keybind
                      is effective in lockscreen.
                  '';
                };
                repeat = lib.mkOption {
                  type = bool;
                  default = false;
                  example = true;
                  description = ''
                    Liuxu (Home): Whether or not the keybind
                      will do effect repeatly when long-pressed.
                  '';
                };
              };
            };
        });
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.liuxu.home.internal.gui.enable {
      liuxu.home.gui.keybinds.execr = with lib.liuxu.wm; [
        (mkNormalExecrBind "missioncenter" "Escape" "Mod")
        (mkNormalExecrBind "kitty" "T" "Mod")
        (mkNormalExecrBind "nautilus" "E" "Mod")
        (mkNormalExecrBind "firefox" "B" "Mod")
        (mkNormalExecrBind "1password" "XF86Favorites" [ ])
      ];
    })
    (
      let
        cfg = config.liuxu.home.gui.keybinds.execr;
      in
      lib.mkIf (cfg != [ ]) (
        lib.mkMerge [
          (lib.mkIf config.liuxu.home.gui.hyprland.enable (
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
                lib.liuxu.hyprland.mkExecrBind {
                  locked = e.opt.lock;
                  repeating = e.opt.repeat;
                } (builtins.concatStringsSep " " e.cmd) (e |> e2Mod2Super |> e2KeyExpr);
            in
            {
              wayland.windowManager.hyprland.settings.bind = map e2Hypr cfg;
            }
          ))
          (lib.mkIf config.liuxu.home.gui.niri.enable {
            liuxu.home.gui.niri.settings = lib.mkAfter (
              lib.kdl.formats.v1 [
                (lib.kdl.extras.niri.include (
                  lib.liuxu.oo toString pkgs.writeText "niri-keybinds-from-common.kdl"
                    config.liuxu.home.internal.gui.keybinds.execr.kdl
                ))
              ]
            );
          })
        ]
      )
    )
  ];
}

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
    gui.keybinds =
      let
        inherit (lib.types)
          bool
          coercedTo
          listOf
          str
          submodule
          ;
        tStrList = coercedTo str lib.singleton (listOf str);
        desc = lib.liuxu.mkHomeDesc;
        commonOpts = {
          mod = lib.mkOption {
            type = tStrList;
            default = [ ];
            example = "Mod";
            description = desc ''
              Keybind's modkey,
                can be a single string or a list of string.
            '';
          };
          key = lib.mkOption {
            type = str;
            example = "R";
            description = desc ''
              Keybind's key,
                must not be empty.
            '';
          };
          opt = {
            lock = lib.mkOption {
              type = bool;
              default = false;
              example = true;
              description = desc ''
                Whether or not the keybind
                  is effective in lockscreen.
              '';
            };
            repeat = lib.mkOption {
              type = bool;
              default = false;
              example = true;
              description = desc ''
                Whether or not the keybind
                  will do effect repeatly when long-pressed.
              '';
            };
          };
        };
      in
      {
        keys = lib.mkOption {
          default = [ ];
          example = [
            {
              type = "execr";
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
          description = desc ''
            Keybinds apply to both Hyprland and Niri.
          '';
          type = listOf (submodule {
            options = commonOpts;
          });
        };
        execr = lib.mkOption {
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
          description = desc ''
            Keybinds that exec a cmd,
              apply to both Hyprland and Niri.
          '';
          type = listOf (submodule {
            options = commonOpts // {
              cmd = lib.mkOption {
                type = tStrList;
                example = [
                  "noctalia"
                  "msg"
                  "panel-toggle"
                  "launcher"
                ];
                description = desc ''
                  Keybind's cmd to exec,
                    must not be empty,
                    can be a single str if there's no args.
                '';
              };
            };
          });
        };
      };
  };

  config = lib.mkMerge [
    (lib.mkIf config.liuxu.home.internal.gui.enable {
      liuxu.home.gui.keybinds = {
        execr = with lib.liuxu.wm; [
          (mkNormalExecrBind "missioncenter" "Escape" "Mod")
          (mkNormalExecrBind "kitty" "T" "Mod")
          (mkNormalExecrBind "nautilus" "E" "Mod")
          (mkNormalExecrBind "zen-beta" "B" "Mod")
          (mkNormalExecrBind [ "1password" "--toggle" ] "XF86Favorites" [ ])
        ];
      };
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
          (lib.mkIf config.liuxu.home.gui.umbriel.enable {
            programs.umbriel.settings.keybinds =
              cfg
              |> map (e: {
                name = "${if e.mod == [ ] then "" else "${e.mod |> builtins.concatStringsSep "+"}+"}${e.key}";
                value = e.cmd |> builtins.concatStringsSep " ";
              })
              |> builtins.listToAttrs;
          })
        ]
      )
    )
  ];
}

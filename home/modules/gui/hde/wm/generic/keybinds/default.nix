{
  config,
  lib,
  ...
}:
{
  options.liuxu.home =
    let
      inherit (lib.types)
        bool
        coercedTo
        enum
        int
        listOf
        nullOr
        singleLineStr
        str
        submodule
        unspecified
        ;
      tStrToList = coercedTo str lib.singleton (listOf str);
      desc = lib.liuxu.mkHomeDesc;
      commonOpts = {
        mod = lib.mkOption {
          type = tStrToList;
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
      internal.gui.keybinds = lib.mkOption {
        default = [ ];
        example = [
          {
            type = "execr";
            mod = "Mod";
            key = "R";
            opt = {
              lock = false;
              repeat = false;
            };
            args = [
              "noctalia"
              "msg"
              "panel-toggle"
              "launcher"
            ];
          }
        ];
        description = desc ''
          Keybinds apply to both Hyprland and Niri.
        '';
        type = listOf (submodule {
          options = commonOpts // {
            type = lib.mkOption {
              type = enum [
                "execr"
                "close-window"
                "focus-workspace"
                "move-window-to-workspace"
              ];
              example = "execr";
              description = desc ''
                Keybinds's action type.
              '';
            };
            args = lib.mkOption {
              type = unspecified;
              example = [
                "noctalia"
                "msg"
                "panel-toggle"
                "launcher"
              ];
              description = desc ''
                Keybind's args.
              '';
            };
          };
        });
      };
      gui.keybinds = {
        close-window = lib.mkOption {
          description = desc ''
            Keybinds that close window,
              target null means close active window.
          '';
          default = [ ];
          example = [
            {
              mod = "Mod";
              key = "Q";
            }
          ];
          type = listOf (submodule {
            options = commonOpts // {
              force = lib.liuxu.mkHomeSwitchOnOption ''
                Whether do force close,
                  some wms may don't support it,
                  then it will fallback to normal close.
              '';
              target = lib.mkOption {
                type = nullOr singleLineStr;
                default = null;
                description = desc ''
                  Window to close,
                    null means active window.
                '';
              };
            };
          });
        };
        execr = lib.mkOption {
          default = [ ];
          example = [
            {
              mod = "Mod";
              key = "R";
              opt = {
                lock = false;
                repeat = false;
              };
              cmd = [
                "noctalia"
                "msg"
                "panel-toggle"
                "launcher"
              ];
            }
          ];
          description = desc ''
            Keybinds that exec a cmd,
              apply to both Hyprland and Niri.
          '';
          type = listOf (submodule {
            options = commonOpts // {
              cmd = lib.mkOption {
                type = tStrToList;
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
        focus-workspace = lib.mkOption {
          description = desc "Keybinds that focus workspace by id.";
          default = [ ];
          example = [
            {
              mod = "Mod";
              key = "1";
              opt = {
                lock = false;
                repeat = false;
              };
              id = 1;
            }
          ];
          type = listOf (submodule {
            options = commonOpts // {
              id = lib.mkOption {
                type = int;
                example = 1;
                description = desc "Workspace id to switch to.";
              };
            };
          });
        };
        move-window-to-workspace = lib.mkOption {
          description = desc ''
            Keybinds that move window to workspace by id,
              target null means move focused window.
          '';
          default = [ ];
          example = [
            {
              mod = [
                "Mod"
                "Shift"
              ];
              key = "1";
              opt = {
                lock = false;
                repeat = false;
              };
              id = 1;
              target = null;
            }
          ];
          type = listOf (submodule {
            options = commonOpts // {
              id = lib.mkOption {
                type = int;
                example = 1;
                description = desc "Workspace id to switch to.";
              };
              target = lib.mkOption {
                type = nullOr singleLineStr;
                default = null;
                description = desc ''
                  Window to move,
                    null means focused window.
                '';
              };
            };
          });
        };
      };
    };

  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    liuxu.home = {
      internal.gui.keybinds =
        let
          cfg = config.liuxu.home.gui.keybinds;
        in
        [ ]
        ++ (
          cfg.close-window
          |> map (e: {
            inherit (e) mod key opt;
            type = "close-window";
            args = { inherit (e) force target; };
          })
        )
        ++ (
          cfg.execr
          |> map (e: {
            inherit (e) mod key opt;
            type = "execr";
            args = e.cmd;
          })
        )
        ++ (
          cfg.focus-workspace
          |> map (e: {
            inherit (e) mod key opt;
            type = "focus-workspace";
            args = e.id;
          })
        )
        ++ (
          cfg.move-window-to-workspace
          |> map (e: {
            inherit (e) mod key opt;
            type = "move-window-to-workspace";
            args = { inherit (e) id target; };
          })
        );
      gui.keybinds =
        let
          forAllNumkeyWs =
            attrs:
            lib.range 0 9
            |> map (
              ki:
              let
                ks = toString ki;
                wi = if ki == 0 then 10 else ki;
              in
              {
                key = ks;
                id = wi;
              }
              // attrs
            );
        in
        {
          close-window = [
            {
              mod = "Mod";
              key = "Q";
            }
            {
              mod = [
                "Mod"
                "Shift"
              ];
              key = "Q";
              force = true;
            }
          ];
          execr = with lib.liuxu.wm; [
            (mkNormalExecrBind "missioncenter" "Escape" "Mod")
            (mkNormalExecrBind "kitty" "T" "Mod")
            (mkNormalExecrBind "nautilus" "E" "Mod")
            (mkNormalExecrBind "zen-beta" "B" "Mod")
            (mkNormalExecrBind [ "1password" "--toggle" ] "XF86Favorites" [ ])
          ];
          focus-workspace = forAllNumkeyWs { mod = "Mod"; };
          move-window-to-workspace = forAllNumkeyWs {
            mod = [
              "Mod"
              "Shift"
            ];
          };
        };
    };
  };
}

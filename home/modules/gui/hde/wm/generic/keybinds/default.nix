{
  config,
  lib,
  ...
}:
{
  options.liuxu.home.gui.keybinds =
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
      generic = lib.mkOption {
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
    };

  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    liuxu.home.gui.keybinds = {
      generic =
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
        );
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
      focus-workspace =
        lib.range 0 9
        |> map (
          ki:
          let
            ks = toString ki;
            wi = if ki == 0 then 10 else ki;
          in
          {
            mod = "Mod";
            key = ks;
            id = wi;
          }
        );
    };
  };
}

{
  config,
  lib,
  ...
}:
let
  inherit (lib.types)
    bool
    coercedTo
    enum
    int
    listOf
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
    opts = {
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
  mkArgs =
    options:
    lib.mkOption {
      type = submodule { inherit options; };
      default = { };
      description = desc "Keybind's arguments.";
    };

  # Single source of truth: every keybind type, its typed args and its docs.
  # The public `wm.keybinds` options are generated from it.
  schema = {
    window-close = {
      args = {
        force = lib.mkOption {
          type = bool;
          default = false;
          example = true;
          description = desc ''
            Whether to force close the window,
              some wms may not support it
              and will fallback to normal close.
          '';
        };
      };
      example = [
        {
          mod = "Mod";
          key = "Q";
          args.force = true;
        }
      ];
      description = desc "Keybinds that close a window.";
    };
    execr = {
      args = {
        cmd = lib.mkOption {
          type = tStrToList;
          example = [
            "noctalia"
            "msg"
          ];
          description = desc ''
            Keybind's command to exec,
              must not be empty,
              can be a single str if there's no args.
          '';
        };
      };
      example = [
        {
          mod = "Mod";
          key = "R";
          args.cmd = [
            "noctalia"
            "msg"
            "panel-toggle"
            "launcher"
          ];
        }
      ];
      description = desc "Keybinds that exec a command.";
    };
    workspace-focus = {
      args = {
        id = lib.mkOption {
          type = int;
          example = 1;
          description = desc "Workspace id to focus.";
        };
      };
      example = [
        {
          mod = "Mod";
          key = "1";
          args.id = 1;
        }
      ];
      description = desc "Keybinds that focus a workspace by id.";
    };
    window-move-to-workspace = {
      args.id = lib.mkOption {
        type = int;
        example = 1;
        description = desc "Workspace id to move the window to.";
      };
      example = [
        {
          mod = [
            "Mod"
            "Shift"
          ];
          key = "1";
          args.id = 1;
        }
      ];
      description = desc "Keybinds that move a window to a workspace by id.";
    };
    column-focus = {
      args.direction = lib.mkOption {
        type = enum [
          "left"
          "right"
        ];
        example = "right";
        description = desc "Direction of next column to focus.";
      };
      example = [
        {
          mod = "Mod";
          key = "Left";
          args.direction = "left";
        }
        {
          mod = "Mod";
          key = "Right";
          args.direction = "right";
        }
      ];
    };
  };
  types = builtins.attrNames schema;
in
{
  options.liuxu.home = {
    gui.wm.keybinds = builtins.mapAttrs (
      _: s:
      lib.mkOption {
        type = listOf (submodule {
          options = commonOpts // {
            args = mkArgs s.args;
          };
        });
        default = [ ];
        inherit (s) example description;
      }
    ) schema;
    internal.gui.wm.keybinds = lib.mkOption {
      internal = true;
      default = [ ];
      type = listOf (submodule {
        options = commonOpts // {
          type = lib.mkOption {
            type = enum types;
            description = desc "Keybind's action type.";
          };
          args = lib.mkOption {
            type = unspecified;
            description = desc "Keybind's arguments.";
          };
        };
      });
      description = desc ''
        Normalized keybinds,
          consumed by the wm backends.
      '';
    };
  };

  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    liuxu.home = {
      internal.gui.wm.keybinds =
        config.liuxu.home.gui.wm.keybinds
        |> builtins.mapAttrs (type: map (e: e // { inherit type; }))
        |> builtins.attrValues
        |> builtins.concatLists;
      gui.wm.keybinds = {
        window-close = [
          {
            key = "Q";
            mod = "Mod";
          }
          {
            key = "Q";
            mod = [
              "Mod"
              "Shift"
            ];
            args.force = true;
          }
        ];
        execr = [
          {
            key = "Escape";
            mod = "Mod";
            args.cmd = "missioncenter";
          }
          {
            key = "T";
            mod = "Mod";
            args.cmd = "kitty";
          }
          {
            key = "E";
            mod = "Mod";
            args.cmd = "nautilus";
          }
          {
            key = "B";
            mod = "Mod";
            args.cmd = "zen-beta";
          }
          {
            key = "XF86Favorites";
            args.cmd = [
              "1password"
              "--toggle"
            ];
          }
        ];
        workspace-focus =
          lib.range 0 9
          |> map (ki: {
            key = toString ki;
            mod = "Mod";
            args.id = if ki == 0 then 10 else ki;
          });
        window-move-to-workspace =
          lib.range 0 9
          |> map (ki: {
            key = toString ki;
            mod = [
              "Mod"
              "Shift"
            ];
            args.id = if ki == 0 then 10 else ki;
          });
        column-focus =
          [
            "left"
            "right"
          ]
          |> map (x: {
            mod = "Mod";
            key = lib.toSentenceCase x;
            args.direction = x;
          });
      };
    };
  };
}

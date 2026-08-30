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

  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    liuxu.home.gui.keybinds = {
      execr = with lib.liuxu.wm; [
        (mkNormalExecrBind "missioncenter" "Escape" "Mod")
        (mkNormalExecrBind "kitty" "T" "Mod")
        (mkNormalExecrBind "nautilus" "E" "Mod")
        (mkNormalExecrBind "zen-beta" "B" "Mod")
        (mkNormalExecrBind [ "1password" "--toggle" ] "XF86Favorites" [ ])
      ];
    };
  };
}

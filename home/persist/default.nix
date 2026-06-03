{ lib, osConfig, ... }:
{
  options.liuxu.home.internal = lib.mkOption {
    internal = true;
    type = lib.types.submodule {
      options = {
        intransience = lib.mkOption {
          type = lib.types.submodule {
            options =
              let
                t = lib.types;
                entry =
                  t.coercedTo t.str
                    (path: {
                      inherit path;
                      method = "bind";
                    })
                    (
                      t.submodule {
                        options = {
                          path = lib.mkOption { type = t.str; };
                          method = lib.mkOption {
                            type = t.enum [
                              "bind"
                              "symlink"
                            ];
                            default = "bind";
                          };
                        };
                      }
                    );
              in
              {
                dirs = lib.mkOption {
                  type = t.listOf entry;
                  default = [ ];
                };
                files = lib.mkOption {
                  type = t.listOf entry;
                  default = [ ];
                };
              };
          };
        };
      };
    };
  };

  config.liuxu.home.internal.intransience = {
    dirs = [
      "Documents"
      "Downloads"
      "Pictures"
      "Videos"

      ".android" # ADB
      ".claude" # Claude Code
      ".local/state/syncthing" # Syncthing

      # Lazyvim
      ".local/share/nvim"
      ".local/state/nvim"
    ]
    ++ lib.optionals osConfig.liuxu.system.better-shell.enable [
      # Zoxide
      # Whole dir needs persist,
      # since there will be temp files.
      {
        path = ".local/share/zoxide";
        method = "symlink";
      }
    ];

    files = [
      ".bash_history" # Bash
      ".claude.json" # Claude Code
      ".ssh/known_hosts" # SSH
      ".local/state/lazygit/state.yml"
    ]
    ++ lib.optionals osConfig.liuxu.system.better-shell.enable [
      ".local/share/fish/fish_history" # Fish
    ];
  };
}

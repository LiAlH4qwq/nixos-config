{ lib, osConfig, ... }:
{
  options.liuxu.home.internal.intransience =
    let
      t = lib.types;
      e =
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
      o = {
        internal = true;
        type = t.listOf e;
        default = [ ];
      };
    in
    {
      dirs = lib.mkOption o;
      files = lib.mkOption o;
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

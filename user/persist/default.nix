{ lib, osConfig, ... }:
{
  options.liuxu.user.internal.intransience =
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

  config.liuxu.user.internal.intransience = {
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
    ];

    files =
      let
        mkSymlinkEntry = path: {
          inherit path;
          method = "symlink";
        };
      in
      [
        ".bash_history" # Bash
        ".claude.json" # Claude Code
        ".ssh/known_hosts" # SSH
        ".local/state/lazygit/state.yml"
      ]
      ++ lib.optionals osConfig.liuxu.system.better-shell.enable [
        ".local/share/fish/fish_history" # Fish
        (mkSymlinkEntry ".local/share/zoxide/db.zo") # Zoxide
      ];
  };
}

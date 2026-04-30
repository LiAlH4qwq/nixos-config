{ lib, ... }:
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
      ".config/mozilla/firefox" # Firefox
      ".config/noctalia/colorschemes" # Noctalia
      ".config/obs-studio" # OBS
      ".local/state/syncthing" # Syncthing
      ".local/share/keyrings" # Gnome Keyring
      ".local/share/materialgram" # Telegram

      # Steam
      ".steam"
      ".local/share/Steam"

      # Lazyvim
      ".local/share/nvim"
      ".local/state/nvim"

      # CEF
      ".config/1Password"
      ".config/Code"
      ".config/discord"
      ".config/QQ"
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
        ".config/gtk-3.0/bookmarks" # Gtk file bookmarks
        ".config/uwsm/default-id" # UWSM
        ".config/VirtualBox/VirtualBox.xml" # Virtualbox
        ".local/share/fish/fish_history" # Fish
        ".local/share/honkers-railway-launcher/config.json"
        (mkSymlinkEntry ".local/share/zoxide/db.zo") # Zoxide
        ".local/state/lazygit/state.yml"

        # Noctalia
        (mkSymlinkEntry ".cache/noctalia/notifications.json") # Notification history
        (mkSymlinkEntry ".cache/noctalia/shell-state.json") # Launcher sorting
        (mkSymlinkEntry ".cache/noctalia/wallpapers.json") # Wallpaper select

        # Fcitx5
        ".local/share/fcitx5/pinyin/user.dict" # New Word
        ".local/share/fcitx5/pinyin/user.history" # Word frequency
      ];
  };
}

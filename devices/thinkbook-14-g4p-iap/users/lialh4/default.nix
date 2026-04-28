{ config, lib, ... }:
{
  users.extraUsers.lialh4 = {
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = [ "wheel" ];
    hashedPasswordFile = config.age.secrets."devices.LiAlH4-Laptop.users.lialh4.password".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPzvkOPfWZmx2zE6cJY4Qz+Z1dKXTgd6Y2I/RgIc86T"
    ];
  };
  home-manager.users.lialh4 = {
    liuxu.user = {
      gui.enable = true;
    };
  };
  libpam-pwdfile-rs = {
    pin.users.lialh4.secret = "$y$j9T$bjCgDKQCZmMhnca0Jw54X1$x4iqH6CXtKuBnFAPaO9M2Cdv6YMB.kPnFUBeGM4vUV4";
  };
  systemd.tmpfiles.settings."11-intransience-fix" =
    let
      cfg = config.intransience.datastores.persist.users.lialh4;
      homeBase = "/home/lialh4";
      persistBase = "/persist/home/lialh4";
      allPaths = map (e: e.fullPath) (cfg.dirs ++ cfg.files);
      getAncestors = path:
        let parent = builtins.dirOf path;
        in if parent == homeBase then [ ] else [ parent ] ++ getAncestors parent;
      ancestorDirs = lib.unique (lib.concatMap getAncestors allPaths);
      mkDirEntry = absPath: {
        "${absPath}".d = {
          user = "lialh4";
          group = "users";
          mode = "0755";
        };
      };
      toPersist = absPath: persistBase + lib.removePrefix homeBase absPath;
    in
    lib.mergeAttrsList (map mkDirEntry ancestorDirs)
    // lib.mergeAttrsList (map (d: mkDirEntry (toPersist d)) ancestorDirs)
    // {
      "${persistBase}".d = {
        user = "lialh4";
        group = "users";
        mode = "0700";
      };
    };
  intransience.datastores.persist.users.lialh4 = {
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

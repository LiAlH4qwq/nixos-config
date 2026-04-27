{ config, ... }:
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
  intransience.datastores.persist.users.lialh4 = {
    dirs = [
      "Documents"
      "Downloads"
      "Pictures"
      "Videos"

      ".android" # ADB
      ".claude" # Claude Code
      ".config/mozilla/firefox" # Firefox
      ".config/obs-studio" # OBS
      ".local/state/nvim" # LazyVim
      ".local/state/syncthing" # Syncthing
      ".local/share/keyrings" # Gnome Keyring
      ".local/share/materialgram" # Telegram

      # Steam
      ".steam"
      ".local/share/Steam"

      # CEF
      ".config/1Password"
      ".config/Code"
      ".config/discord"
      ".config/QQ"
    ];
    files = [
      ".bash_history" # Bash
      ".claude.json" # Claude Code
      ".ssh/known_hosts" # SSH
      ".config/uwsm/default-id" # UWSM
      ".config/VirtualBox/VirtualBox.xml" # Virtualbox
      ".local/share/fish/fish_history" # Fish
      ".local/share/honkers-railway-launcher/config.json"
      ".local/share/zoxide/db.zo" # Zoxide

      # Steam
      ".steampath"
      ".steampid"

      # Noctalia
      ".cache/noctalia/notifications.json" # Notification history
      ".cache/noctalia/shell-state.json" # Launcher sorting
      ".cache/noctalia/wallpapers.json" # Wallpaper select

      # Fcitx5
      ".local/share/fcitx5/pinyin/user.dict" # New Word
      ".local/share/fcitx5/pinyin/user.history" # Word frequency
    ];
  };
}

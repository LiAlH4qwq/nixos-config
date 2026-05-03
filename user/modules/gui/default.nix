{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  imports = [
    ./hde
    ./kitty
    ./vscode
  ];

  options.liuxu.user.gui.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu (User): Whether to enable GUI.
        Provides a full functional Hyprland Desktop Environment
    '';
  };

  config = lib.mkIf config.liuxu.user.gui.enable {
    programs = {
      firefox.enable = true;
      obs-studio.enable = true;
      discord = {
        enable = true;
        settings = {
          SKIP_HOST_UPDATE = true;
        };
      };
      ssh = {
        enable = true;
        # See: https://mynixos.com/home-manager/option/programs.ssh.enableDefaultConfig
        enableDefaultConfig = false;
        matchBlocks."*".identityAgent = "~/.1password/agent.sock";
      };
    };

    home = {
      sessionVariables = {
        "NIXOS_OZONE_WL" = 1;
      };
      # These programs hasn't been availible as programs config. :(
      packages = with pkgs; [
        nautilus # explorer.exe
        mission-center # taskmgr.exe
        clementine # Music player
        clapper # Video player
        wev # Input inspect
        inkscape
        materialgram # Telegram with material design
        qq
        wechat
        wemeet
        wpsoffice-cn
      ];
    };

    liuxu.user.internal.intransience = {
      dirs = [
        ".config/mozilla/firefox" # Firefox
        ".config/noctalia/colorschemes" # Noctalia
        ".config/obs-studio" # OBS
        ".config/Clementine" # Clementine
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

      files =
        let
          mkSymlinkEntry = path: {
            inherit path;
            method = "symlink";
          };
        in
        [
          ".config/gtk-3.0/bookmarks" # Gtk file bookmarks
          ".config/uwsm/default-id" # UWSM

          # Noctalia
          (mkSymlinkEntry ".cache/noctalia/notifications.json") # Notification history
          (mkSymlinkEntry ".cache/noctalia/shell-state.json") # Launcher sorting
          (mkSymlinkEntry ".cache/noctalia/wallpapers.json") # Wallpaper select

          # Fcitx5
          ".local/share/fcitx5/pinyin/user.dict" # New Word
          ".local/share/fcitx5/pinyin/user.history" # Word frequency
        ]
        ++ lib.optional osConfig.liuxu.nixos.virtualbox.enable ".config/VirtualBox/VirtualBox.xml" # Virtualbox
        ++ lib.optional osConfig.liuxu.nixos.user-support.gui.agl.enable ".local/share/honkers-railway-launcher/config.json";
    };
  };
}

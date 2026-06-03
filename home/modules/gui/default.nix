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

  options.liuxu.home.gui.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu (User): Whether to enable GUI.
        Provides a full functional Hyprland Desktop Environment
    '';
  };

  config = lib.mkIf config.liuxu.home.gui.enable {
    programs = {
      firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
      };
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
        settings."*".identityAgent = "~/.1password/agent.sock";
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

    liuxu.home.internal.intransience = {
      dirs = [
        ".config/mozilla/firefox" # Firefox
        ".config/noctalia/colorschemes" # Noctalia
        ".config/obs-studio" # OBS
        ".config/Clementine" # Clementine
        # Fcitx5
        # It will be tmpfiles here,
        # so this dir should be intransienced,
        # otherwise it will failed to update dict files.
        ".local/share/fcitx5/pinyin"
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

          # Noctalia
          (mkSymlinkEntry ".cache/noctalia/notifications.json") # Notification history
          (mkSymlinkEntry ".cache/noctalia/shell-state.json") # Launcher sorting
          (mkSymlinkEntry ".cache/noctalia/wallpapers.json") # Wallpaper select
        ]
        ++ lib.optional osConfig.liuxu.nixos.virtualbox.enable ".config/VirtualBox/VirtualBox.xml" # Virtualbox
        ++ lib.optional osConfig.liuxu.nixos.user-support.gui.agl.enable ".local/share/honkers-railway-launcher/config.json";
    };
  };
}

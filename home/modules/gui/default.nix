{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  imports = [
    ./agl
    ./firefox-like
    ./hde
    ./kitty
    ./vscode
  ];

  options.liuxu.home.internal.gui.enable = lib.mkOption {
    type = lib.types.bool;
    internal = true;
    readOnly = true;
    default = config.liuxu.home.gui.hyprland.enable || config.liuxu.home.gui.niri.enable;
  };

  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    programs = {
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
        ".config/obs-studio" # OBS
        ".config/Clementine" # Clementine
        ".local/share/keyrings" # Gnome Keyring
        ".local/share/materialgram" # Telegram

        # WPS
        ".config/Kingsoft"
        ".local/share/Kingsoft"

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
        ".config/gtk-3.0/bookmarks" # Gtk file bookmarks
      ]
      ++ lib.optional osConfig.liuxu.nixos.virtualbox.enable ".config/VirtualBox/VirtualBox.xml"; # Virtualbox
    };
  };
}

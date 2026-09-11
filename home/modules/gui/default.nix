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
    ./opt
  ];

  options.liuxu.home.internal.gui.enable = lib.liuxu.mkComputedSwitchOption (
    config.liuxu.home.gui.hyprland.enable
    || config.liuxu.home.gui.niri.enable
    || config.liuxu.home.gui.umbriel.enable
  );

  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    home = {
      sessionVariables = {
        NIXOS_OZONE_WL = 1;
        SSH_AUTH_SOCK = "~/.bitwarden-ssh-agent.sock";
      };
      # These programs hasn't been availible as programs config. :(
      packages = with pkgs; [
        nautilus # explorer.exe
        mission-center # taskmgr.exe
        gnome-text-editor # notepad.exe
        clementine # Music player
        clapper # Video player
        wev # Input inspect
        materialgram # Telegram with material design
      ];
    };

    liuxu.home.internal.intransience = {
      dirs = [
        ".config/Clementine" # Clementine
        ".local/share/keyrings" # Gnome Keyring
        ".local/share/materialgram" # Telegram

        # CEF
        ".config/1Password"
        ".config/Bitwarden"
      ];

      files = [
        ".config/gtk-3.0/bookmarks" # Gtk file bookmarks
      ]
      ++ lib.optional osConfig.liuxu.nixos.virtualbox.enable ".config/VirtualBox/VirtualBox.xml"; # Virtualbox
    };
  };
}

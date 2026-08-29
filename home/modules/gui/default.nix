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
    config.liuxu.home.gui.hyprland.enable || config.liuxu.home.gui.niri.enable
  );

  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    programs = {
      ssh.settings."*".identityAgent = "~/.1password/agent.sock";
      git.settings.gpg.ssh.program = lib.getExe' pkgs._1password-gui "op-ssh-sign";
    };

    home = {
      sessionVariables = {
        "NIXOS_OZONE_WL" = 1;
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
      ];

      files = [
        ".config/gtk-3.0/bookmarks" # Gtk file bookmarks
      ]
      ++ lib.optional osConfig.liuxu.nixos.virtualbox.enable ".config/VirtualBox/VirtualBox.xml"; # Virtualbox
    };
  };
}

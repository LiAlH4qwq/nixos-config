{
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  here = {
    switch = {
      generate = true;
      default = true;
      premise = {
        any = [
          [
            "here"
            "hyprland"
          ]
          [
            "here"
            "niri"
          ]
          [
            "here"
            "umbriel"
          ]
        ];
      };
    };
    apply = {
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
          gnome-calculator # calc.exe
          clementine # Music player
          clapper # Video player
          valuta # Currency converter
          wev # Input inspect
          materialgram # Telegram with material design
        ];
      };

      liuxu.home.preservation = {
        directories = [
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
  };
}

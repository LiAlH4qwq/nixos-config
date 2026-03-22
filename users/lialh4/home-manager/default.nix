{ pkgs, ... }:
{
  imports = [
    ./state
    ./i18n
    ./xcursor
    ./hypr
    ./mako
    ./syncthing
    ./vicinae
    ./vscode
  ];

  gtk = rec {
    enable = true;
    colorScheme = "light";
    theme = gtk4.theme;
    iconTheme = gtk4.iconTheme;
    # gtk4 needs to force enable.
    gtk4 = {
      enable = true;
      theme = {
        name = "rose-pine-dawn";
        package = pkgs.rose-pine-gtk-theme;
      };
      iconTheme = {
        name = "rose-pine-dawn";
        package = pkgs.rose-pine-icon-theme;
      };
    };
  };

  # these hasn't been available as a program in release 25.11.
  home.packages = with pkgs; [
    wev # Input inspect tool
    nixfmt # Nix file formatter
    nautilus # Explorer
    lollypop # Music player
    clapper # Video player
    materialgram # Telegram with material design
    wl-clipboard-rs # Clipboard history of vicinae
  ];

  # when using genAttrs,
  # it will broken with error:
  # programs field already defined.
  programs = {
    home-manager.enable = true;
    fish.enable = true;
    firefox.enable = true;
    kitty.enable = true;
    foot.enable = true;
    git.enable = true;
    ashell.enable = true;
  };
  programs.ashell.settings = import ./ashell;
  programs.kitty.settings = import ./kitty;
  programs.git.settings = import ./git;
}

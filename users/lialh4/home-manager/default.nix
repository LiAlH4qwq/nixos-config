{ pkgs, ... }:
{
  imports = [
    ./state
    ./git
    ./gui
    ./syncthing
  ];

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
  };
}

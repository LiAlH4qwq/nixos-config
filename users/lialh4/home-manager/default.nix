{ pkgs, ... }:
{
  imports = [
    ./state
    ./bun
    ./git
    ./gui
    ./syncthing
  ];

  # these hasn't been available as a program in release 25.11.
  home.packages = with pkgs; [
    wev # Input inspect tool
    nixd # Nix LSP
    nixfmt # Nix formatter
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

{ pkgs, ... }:
{
  imports = [
    ./state
    ./bun
    ./git
    ./gui
    ./syncthing
    ./shell
  ];

  # these hasn't been available as a program in release 25.11.
  home.packages = with pkgs; [
    wev # Input inspect tool
    nixd # Nix LSP
    nixfmt # Nix formatter
    wl-clipboard-rs # Clipboard history of vicinae
  ];

  # Home manager need this to bootstrap.
  programs.home-manager.enable = true;
}

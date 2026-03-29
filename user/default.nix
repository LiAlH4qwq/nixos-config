{ pkgs, ... }:
{
  imports = [
    ./bun
    ./claude-code
    ./git
    ./modules
    ./syncthing
    ./shell
    ./uv
  ];

  # these hasn't been available as a program in release 25.11.
  home.packages = with pkgs; [
    fastfetch
    wev # Input inspect tool
    nixd # Nix LSP
    nixfmt # Nix formatter
    reptyr # Re-attach programs to pty
    wl-clipboard-rs # Clipboard history of vicinae
  ];

  # Home manager need this to bootstrap.
  programs.home-manager.enable = true;
}

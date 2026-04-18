{ pkgs, ... }:
{
  imports = [
    ./bun
    ./claude-code
    ./git
    ./lazyvim
    ./modules
    ./syncthing
    ./shell
    ./uv
    ./yazi
  ];

  # these hasn't been available as a program in release 25.11.
  home.packages = with pkgs; [
    android-tools
    cargo
    fastfetch
    reptyr # Re-attach programs to pty
  ];

  programs = {
    zellij.enable = true;
    lazygit.enable = true;

    # Home manager need this to bootstrap.
    home-manager.enable = true;
  };
}

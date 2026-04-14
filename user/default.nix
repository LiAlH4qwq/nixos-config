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
    ./yazi
  ];

  # these hasn't been available as a program in release 25.11.
  home.packages = with pkgs; [
    cargo
    fastfetch
    reptyr # Re-attach programs to pty
  ];

  programs = {
    zellij.enable = true;

    # Home manager need this to bootstrap.
    home-manager.enable = true;
  };
}

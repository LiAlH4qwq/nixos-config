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

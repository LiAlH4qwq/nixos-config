{ osConfig, pkgs, ... }:
{
  imports = [
    ./bun
    ./claude-code
    ./git
    ./lazyvim
    ./modules
    ./persist
    ./shell
    ./syncthing
    ./uv
    ./yazi
  ];

  # these hasn't been available as a program in release 25.11.
  home = {
    stateVersion = osConfig.liuxu.system.version-when-installed;
    packages = with pkgs; [
      android-tools
      cargo
      fastfetch
      reptyr # Re-attach programs to pty
    ];
  };

  programs = {
    zellij.enable = true;
    lazygit.enable = true;

    # Home manager need this to bootstrap.
    home-manager.enable = true;
  };
}

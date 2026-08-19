{ osConfig, pkgs, ... }:
{
  imports = [
    ./bun
    ./git
    ./flatpak
    ./modules
    ./persist
    ./shell
    ./ssh
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
      nixd # Nix LSP
      nixfmt # Nix formatter
      reptyr # Re-attach programs to pty
      typescript
    ];
  };

  programs = {
    lazygit.enable = true;
    pandoc.enable = true;
    zellij.enable = true;

    # Home manager need this to bootstrap.
    home-manager.enable = true;
  };
}

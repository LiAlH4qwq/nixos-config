{
  lib,
  osConfig,
  pkgs,
  scopes,
  ...
}:
let
  tree =
    base: dir:
    lib.nix-tree-modules.mkTree {
      inherit scopes base dir;
      scopeName = "home";
    };
in
{
  imports = [
    (tree [ "git" ] ./git)
    (tree [ "flatpak" ] ./flatpak)
    (tree [ ] ./globals)
    ./modules
    (tree [ "preservation" ] ./preservation)
    (tree [ "syncthing" ] ./syncthing)
    (tree [ "uv" ] ./uv)
    (tree [ "yazi" ] ./yazi)
  ];

  # these hasn't been available as a program in release 25.11.
  home = {
    stateVersion = osConfig.liuxu.system.version-when-installed;
    packages = with pkgs; [
      android-tools
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

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
    lib.liuxu.mkTree {
      inherit scopes base dir;
      scopeName = "home";
    };
in
{
  imports = [
    (tree [ ] ./git)
    (tree [ ] ./flatpak)
    (tree [ ] ./globals)
    ./modules
    (tree [ ] ./persist)
    (tree [ ] ./syncthing)
    (tree [ ] ./uv)
    (tree [ ] ./yazi)
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

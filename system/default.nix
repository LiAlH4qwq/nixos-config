{
  flakeConfig,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./modules
    ./nix
    ./ssh
    ./uutils
  ];

  programs = {
    # Used when rebuilding.
    git.enable = true;
    nix-ld.enable = true;
  };

  nixpkgs = {
    # We won't sacrifice our experience for FOSS.
    config.allowUnfree = true;
    overlays = [
      flakeConfig.flake.overlays.default
      inputs.tg-transient.overlays.default
      inputs.cachyos-kernel.overlays.pinned
      inputs.firefox-addons.overlays.default
    ];
  };
}

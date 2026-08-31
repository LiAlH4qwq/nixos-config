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
    ./secrets
    ./ssh
    ./uutils
  ];

  programs = {
    # Used when rebuilding.
    git.enable = true;
    nix-ld.enable = true;
  };

  environment.systemPackages = [
    pkgs.ragenix
  ];

  nixpkgs = {
    # We won't sacrifice our experience for FOSS.
    config.allowUnfree = true;
    overlays = [
      flakeConfig.flake.overlays.default
      inputs.dsh.overlays.default
      inputs.ragenix.overlays.default
      inputs.tg-transient.overlays.default
      inputs.cachyos-kernel.overlays.pinned
      inputs.firefox-addons.overlays.default
    ];
  };
}

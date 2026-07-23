{
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
      inputs.self.overlays.default
      inputs.ragenix.overlays.default
      inputs.niri-nix.overlays.niri-nix
      inputs.firefox-addons.overlays.default
    ];
  };
}

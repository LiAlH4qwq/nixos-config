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

  environment.systemPackages = [
    pkgs.ragenix
    pkgs.deploy-rs.deploy-rs
  ];

  nixpkgs = {
    # We won't sacrifice our experience for FOSS.
    config.allowUnfree = true;
    overlays = [
      inputs.self.overlays.default
      inputs.rust-overlay.overlays.default
      inputs.ragenix.overlays.default
      inputs.deploy-rs.overlays.default
    ];
  };
}

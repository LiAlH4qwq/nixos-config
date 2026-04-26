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
    # Used by `nixos-rebuild`
    git.enable = true;
    nix-ld = {
      enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.ragenix
    pkgs.deploy-rs.deploy-rs
  ];

  nixpkgs.overlays = [
    inputs.self.overlays.default
    inputs.rust-overlay.overlays.default
    inputs.ragenix.overlays.default
    inputs.deploy-rs.overlays.default
  ];

}

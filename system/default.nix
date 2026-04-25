{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./i18n
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
}

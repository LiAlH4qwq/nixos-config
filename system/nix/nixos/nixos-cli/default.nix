{ inputs, pkgs, ... }:
{
  programs.nixos-cli = {
    enable = true;
    # The wrapped package insist on calling nix instead of lix,
    # even didn't affect by overlay, so strange.
    # And when enable `pipe-operator` experimental feature in lix,
    # nix will failed with `unknown experimental feature`,
    # since nix needs `pipe-operators` (with `s`).
    package = inputs.nixos-cli.packages.${pkgs.stdenv.hostPlatform.system}.nixos-cli-unwrapped;
    settings = {
      apply = {
        reexec_as_root = true; # Continue even when forgetting `sudo`
        # Disable due to unusable.
        # use_nom = true; # More friendly build output message
      };
      confirmation.always = true;
      differ.query_derivations = true; # More accurate pkg version info.
      root = {
        command = "run0";
      };
    };
  };
  nix.settings = {
    substituters = [
      "https://watersucks.cachix.org"
    ];
    trusted-public-keys = [
      "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
    ];
  };
  environment.systemPackages = [
    pkgs.nom
  ];
}

{ config, lib, ... }:
{
  imports = [
    (lib.mkAliasOptionModule
      [
        "environment"
        "systemPackages"
      ]
      [
        "environment"
        "packages"
      ]
    )
    (lib.mkAliasOptionModule [ "nix" "settings" "substituters" ] [ "nix" "substituters" ])
    (lib.mkAliasOptionModule [ "nix" "settings" "trusted-public-keys" ] [ "nix" "trustedPublicKeys" ])
  ];

  options.nix.settings.experimental-features = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [
      "flakes"
      "nix-command"
      "pipe-operator"
    ];
    description = ''
      Liuxu (Droid): Ported from NixOS options.
    '';
  };

  config = {
    nix.extraOptions =
      let
        cfg = config.nix.settings.experimental-features;
      in
      lib.optional (cfg != [ ]) (
        lib.mkBefore "experimental-features = ${builtins.concatStringsSep " " cfg}"
      );
  };
}

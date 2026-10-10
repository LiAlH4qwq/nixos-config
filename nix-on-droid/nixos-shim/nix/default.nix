{ config, lib, ... }: {
  imports = [
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

  options.nix.settings.trusted-substituters = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''
      Liuxu (Droid): Ported from NixOS options.
    '';
  };

  config = {
    nix.extraOptions =
      let
        exp = config.nix.settings.experimental-features;
        ts = config.nix.settings.trusted-substituters;
      in
      (lib.optional (exp != [ ]) (
        lib.mkBefore "experimental-features = ${builtins.concatStringsSep " " exp}"
      ))
      ++ (lib.optional (ts != [ ]) "trusted-substituters = ${builtins.concatStringsSep " " ts}");
  };
}

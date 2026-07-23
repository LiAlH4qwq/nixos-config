{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./nix
    ./programs
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
  ];

  options.users.defaultUserShell = lib.mkOption {
    type = lib.types.package;
    default = pkgs.bash;
    example = pkgs.fish;
    description = ''
      Liuxu (Droid): Ported from NixOS options.
    '';
  };

  config.user.shell = lib.getExe config.users.defaultUserShell;
}

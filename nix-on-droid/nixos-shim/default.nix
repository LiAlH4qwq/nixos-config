{
  config,
  lib,
  pkgs,
  ...
}:
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
  ];

  options.users.defaultUserShell =
    let
      desc = lib.liuxu.mkDroidDesc;
    in
    lib.mkOption {
      type = lib.types.package;
      default = pkgs.bash;
      example = pkgs.fish;
      description = desc ''
        Ported from NixOS options.
      '';
    };

  config.user.shell = lib.getExe config.users.defaultUserShell;
}

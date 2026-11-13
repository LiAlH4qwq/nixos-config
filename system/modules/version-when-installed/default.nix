{ config, lib, ... }:
{
  here.option =
    let
      desc = lib.liuxu.mkOsDesc;
    in
    lib.mkOption {
      type = lib.types.singleLineStr;
      default = "25.11";
      example = "26.05";
      description = desc ''
        Reflects NixOS version **when system get installed**.
          Do not change it after install **unless needed**!
      '';
    };

  here.apply.system.stateVersion = config.liuxu.system.version-when-installed;
}

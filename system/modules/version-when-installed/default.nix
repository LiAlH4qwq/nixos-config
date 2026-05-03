{ config, lib, ... }:
{
  options.liuxu.system.version-when-installed = lib.mkOption {
    type = lib.types.singleLineStr;
    default = "25.11";
    example = "26.05";
    description = ''
      Liuxu: Reflects NixOS version **when system get installed**.
        Do not change it after install **unless needed**!
    '';
  };

  config = {
    system.stateVersion = config.liuxu.system.version-when-installed;
  };
}

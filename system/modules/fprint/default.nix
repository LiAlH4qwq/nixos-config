{ config, lib, ... }:
{
  options.liuxu.system.fprint.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable the fingerprint reader support.
    '';
  };

  config = lib.mkIf config.liuxu.system.fprint.enable {
    services.fprintd = {
      enable = true;
    };
  };
}

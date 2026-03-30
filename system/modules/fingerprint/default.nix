{ config, lib, ... }:
{
  options.liuxu.system.fingerprint.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable the fingerprint reader support.
    '';
  };

  config = lib.mkIf config.liuxu.system.fingerprint.enable {
    services.fprintd = {
      enable = true;
    };
    # Make enrolled fingerprints persistent.
    environment.persistence."/persist".directories = [
      "/var/lib/fprint"
    ];
  };
}

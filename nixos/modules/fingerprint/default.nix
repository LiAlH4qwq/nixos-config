{ config, lib, ... }:
{
  options.liuxu.nixos.fingerprint.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable the fingerprint reader support.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.fingerprint.enable {
    services.fprintd = {
      enable = true;
    };
    # Make enrolled fingerprints persistent.
    intransience.datastores.persist.dirs = [ "/var/lib/fprint" ];
    # Why default settings enable fprint auth for it?
    security.pam.services.sshd.fprintAuth = false;
  };
}

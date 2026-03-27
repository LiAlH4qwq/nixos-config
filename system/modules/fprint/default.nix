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
    # Hyprlock supports parallel fingerprint and password auth like GDM.
    # But this default configuration cause a non-paralell and no-prompt auth.
    security.pam.services.hyprlock.fprintAuth = false;
    # Make enrolled fingerprints persistent.
    environment.persistence."/persist".directories = [
      "/var/lib/fprint"
    ];
  };
}

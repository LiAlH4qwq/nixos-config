{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.system.secureboot.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable the secure boot support.
        Currently enables lanzaboote.
    '';
  };

  config = lib.mkIf config.liuxu.system.secureboot.enable {
    boot = {
      loader.systemd-boot.enable = false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
    environment.systemPackages = with pkgs; [
      sbctl
    ];
  };
}

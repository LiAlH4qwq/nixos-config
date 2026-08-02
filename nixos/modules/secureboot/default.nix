{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  options.liuxu.nixos.secureboot.enable = lib.liuxu.modules.mkLiuxuSwitchOnOption ''
    Whether to enable the secure boot support.
      Currently enables lanzaboote.
  '';

  config = lib.mkIf config.liuxu.nixos.secureboot.enable {
    boot = {
      loader.systemd-boot.enable = false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        autoGenerateKeys.enable = true;
        autoEnrollKeys = {
          enable = true;
          autoReboot = true;
          # Unspported in v1.1.0 😭.
          # includeFirmwareBuiltinKeys = true;
        };
      };
    };
    environment = {
      systemPackages = with pkgs; [
        sbctl
      ];
    };
    # Make secureboot keys persistent.
    intransience.datastores.persist.dirs = [ "/var/lib/sbctl" ];

  };
}

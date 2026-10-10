{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.default ];

  here = {
    switch.generate = true;
    apply = {
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
      preservation.preserveAt.persist.directories = [ "/var/lib/sbctl" ];
    };
  };
}

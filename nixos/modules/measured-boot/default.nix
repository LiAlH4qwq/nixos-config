{ config, ... }:
{
  here.config = {
    boot.lanzaboote = {
      enable = true;
      configurationLimit = 8;
      measuredBoot = {
        enable = true;
        autoCryptenroll = {
          enable = true;
          autoReboot = true;
          device = config.boot.initrd.luks.devices.root.device;
        };
        pcrs = [
          0
          # 1
          # 2
          # 3
          4
          7
        ];
      };
    };
    preservation.preserveAt.persist = {
      directories = [
        config.boot.lanzaboote.measuredBoot.pcrlockDirectory
        "/var/lib/auto-cryptenroll"
      ];
      files = [ config.boot.lanzaboote.measuredBoot.pcrlockPolicy ];
    };
  };
}

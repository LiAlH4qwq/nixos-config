{
  config,
  lib,
  ...
}:
{
  options.liuxu.nixos.measured-boot.enable = lib.liuxu.modules.mkOsSwitchOnOption ''
    Whether to enable measured-boot.
      See: https://nix-community.github.io/lanzaboote/explanation/measured-boot.html
      And: https://nix-community.github.io/lanzaboote/how-to-guides/enable-measured-boot.html
  '';

  config = lib.mkIf config.liuxu.nixos.measured-boot.enable {
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
    intransience.datastores.persist = {
      dirs = [
        config.boot.lanzaboote.measuredBoot.pcrlockDirectory
        "/var/lib/auto-cryptenroll"
      ];
      files = [ config.boot.lanzaboote.measuredBoot.pcrlockPolicy ];
    };
  };
}

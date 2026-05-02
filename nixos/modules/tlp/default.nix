{
  config,
  lib,
  ...
}:
{
  imports = [ ./backports ];

  options.liuxu.nixos.tlp = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liuxu.nixos.laptop.enable;
      example = false;
      description = ''
        Liuxu: Whether to enable the TLP,
          a better power management suit,
          replacing `power-profiles-daemon`.
          Default enable when `laptop` enabled.
      '';
    };
    disks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "NVME_123456789012"
        "SATA_210987654321"
      ];
      description = ''
        Liuxu: Disks managed TLP.
          Can be obtained using `ls /dev/disks/by-id`
      '';
    };
  };

  config = lib.mkIf config.liuxu.nixos.tlp.enable {
    services = {
      power-profiles-daemon.enable = false;
      tlp = {
        enable = true;
        pd.enable = true;
        settings = {
          # Always auto switch profiles.
          TLP_AUTO_SWITCH = 1;
          # Unavailable in tlp 1.9.1.
          # TLP_PROFILE_AC="PRF";
          # TLP_PROFILE_BAT="SAV";
          # TLP_PROFILE_DEFAULT="SAV";
          # Have to be remove when updated to tlp 1.10
          TLP_DEFAULT_MODE = "SAV";
          # Sound power save also enabled for AC.
          # See: https://linrunner.de/tlp/settings/audio.html#sound-power-save-on-ac-bat
          # Power off optical devices on BAT
          BAY_POWEROFF_ON_AC = 0;
          BAY_POWEROFF_ON_BAT = 1;
          DISK_DEVICES = config.liuxu.nixos.tlp.disks |> builtins.concatStringsSep " ";
          DISK_IOSCHED =
            config.liuxu.nixos.tlp.disks |> map (_: "mq-deadline") |> builtins.concatStringsSep " ";
          NMI_WATCHDOG = 0;
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 1;
          CPU_BOOST_ON_SAV = 0;
          CPU_HWP_DYN_BOOST_ON_AC = 1;
          CPU_HWP_DYN_BOOST_ON_BAT = 1;
          CPU_HWP_DYN_BOOST_ON_SAV = 0;
          DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth nfc wifi wwan";
        };
      };
    };
  };
}

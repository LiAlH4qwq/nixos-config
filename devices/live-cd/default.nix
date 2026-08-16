{ config, inputs, ... }: {
  imports = [
    ./users
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
  ];

  liuxu = {
    nixos = {
      bluetooth.enable = true;
      brightness.enable = true;
      laptop.enable = true;
      pin.enable = false;
      user-support.gui = {
        display-manager.enable = false;
        plymouth.enable = false;
      };
    };
    system.version-when-installed = config.system.nixos.release;
  };

  isoImage = {
    makeEfiBootable = true;
    makeUsbBootable = true;
  };

  intransience.enable = false;

  hardware.enableAllHardware = true;

  boot.kernelParams = [
    "systemd.log_level=debug"
    "systemd.log_target=console"
  ];
}

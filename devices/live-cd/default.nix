{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./users
    inputs.pe-key-scanner.nixosModules.default
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
  ];

  liuxu = {
    nixos = {
      bluetooth.enable = true;
      brightness.enable = true;
      laptop.enable = true;
      pin.enable = false;
    };
    system.version-when-installed = config.system.nixos.release;
  };

  environment.systemPackages = with pkgs; [ cryptsetup ];

  isoImage = {
    makeEfiBootable = true;
    makeUsbBootable = true;
  };

  services.pe-key-scanner = {
    enable = true;
    service.restartOnSuccess = [ "sops-install-secrets.service" ];
  };

  preservation.enable = false;

  hardware.enableAllHardware = true;

  boot.kernelParams = [
    "systemd.log_level=debug"
    "systemd.log_target=console"
  ];
}

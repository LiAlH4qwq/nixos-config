{
  config,
  inputs,
  lib,
  pkgs,
  scopes,
  ...
}:
{
  imports = [
    (lib.nix-tree-modules.mkTree {
      inherit scopes;
      scopeName = "device";
      dir = ./users;
      base = [ "users" ];
    })
    inputs.pe-key-scanner.nixosModules.default
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
  ];

  liuxu = {
    nixos = {
      bluetooth.enable = true;
      brightness.enable = true;
      laptop.enable = true;
      pin.enable = false;
      vaultix = {
        # The live environment finds the admin SSH key on removable media.
        hostPubkey = config.liuxu.id.lialh4.ssh.key.primary;
        hostKeys = [
          {
            path = "/run/pe-key-scanner/ssh.key";
            type = "ed25519";
          }
          {
            path = "/persist/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };
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
    service.restartOnSuccess = [ "vaultix-activate.service" ];
  };

  preservation.enable = false;

  hardware.enableAllHardware = true;

  boot.kernelParams = [
    "systemd.log_level=debug"
    "systemd.log_target=console"
  ];
}

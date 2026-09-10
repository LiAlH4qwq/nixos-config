{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-onecloud.nixosModules.default
    ./users
  ];

  nixpkgs.buildPlatform.system = "x86_64-linux";

  liuxu.nixos = {
    btrbk.enable = false;
    network.enable = false;
  };

  liuxu.system.better-shell.enable = false;

  boot = {
    loader.systemd-boot.enable = false;
    kernelPackages = pkgs.linuxPackagesFor pkgs.onecloud.kernel;
  };

  documentation = {
    # enable = false;
    man.man-db.enable = false;
  };

  intransience.enable = false;

  hardware.onecloud = {
    enable = true;
    sdImage.enable = true;
  };

  services = {
    kmscon.enable = lib.mkForce false;
    smartd.enable = lib.mkForce false;
  };

  nixpkgs.overlays = [
    (final: prev: {
      nix-output-monitor = final.runCommand "nix-output-monitor-stub" { } ''
        mkdir -p $out/bin && printf '#!/bin/sh\nexec cat\n' > $out/bin/nom && chmod +x $out/bin/nom
      '';
      btdu = final.runCommand "btdu-stub" { } ''
        mkdir -p $out/bin && printf '#!/bin/sh\nexit 0\n' > $out/bin/btdu && chmod +x $out/bin/btdu
      '';
    })
  ];
}

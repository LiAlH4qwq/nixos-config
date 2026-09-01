{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (lib.mkAliasOptionModule [ "liuxu" "nixos" "kernel" "package" ] [ "boot" "kernelPackages" ])
    (lib.mkAliasOptionModule [ "liuxu" "nixos" "kernel" "params" ] [ "boot" "kernelParams" ])
  ];

  boot = {
    loader = {
      timeout = lib.mkDefault 0;
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkDefault true;
    };
    initrd.systemd.enable = true;
    kernel.sysctl."kernel.sysrq" = 1;
    kernelPackages = lib.mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
  };
}

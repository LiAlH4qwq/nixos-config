{
  lib,
  ...
}:
{
  boot = {
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkDefault true;
    };
    initrd.systemd.enable = true;
    kernel.sysctl."kernel.sysrq" = 1;
  };
}

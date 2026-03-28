{ lib, pkgs, ... }:
{
  boot = {
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = lib.mkDefault true;
        configurationLimit = 5;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
    ];
    consoleLogLevel = 0;
    # 😭 It's unsupported by NixOS 25.11.
    # stage2Greeting = "Liuxu: Welcome!";
    initrd = {
      systemd.enable = true;
      availableKernelModules = [
        "i915"
      ];
    };
    plymouth = {
      enable = true;
      font = "${pkgs.maple-mono.NF-CN}/share/fonts/truetype/MapleMono-NF-CN-Regular.ttf";
    };
  };
}

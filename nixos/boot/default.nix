{
  lib,
  options,
  pkgs,
  ...
}:
{
  boot = {
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = lib.mkDefault true;
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
      # Temporary fix.
      # See: https://github.com/NixOS/nixpkgs/pull/510953
      luks.cryptoModules = lib.remove "aes_generic" options.boot.initrd.luks.cryptoModules.default;
    };
    plymouth = {
      enable = true;
      font = "${pkgs.maple-mono.NF-CN-unhinted}/share/fonts/truetype/MapleMono-NF-CN-Regular.ttf";
    };
  };
}

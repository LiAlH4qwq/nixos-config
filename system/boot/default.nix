{ pkgs, ... }:
{
  imports = [
    ./kernel
  ];

  boot = {
    loader = {
      timeout = 0;
      systemd-boot = {
        configurationLimit = 5;
      };
    };
    consoleLogLevel = 0;
    # 😭 It's unsupported by NixOS 25.11.
    # stage2Greeting = "Liuxu: Welcome!";
    plymouth = {
      enable = true;
      font = "${pkgs.maple-mono.NF-CN}/share/fonts/truetype/MapleMono-NF-CN-Regular.ttf";
    };
    initrd = {
      systemd.enable = true;
      availableKernelModules = [
        "i915"
      ];
    };
    kernelParams = [
      "quiet"
      "splash"
    ];
  };
}

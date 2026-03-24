{ pkgs, ... }:
{
  imports = [
    ./kernel
  ];

  boot = {
    consoleLogLevel = 0;
    stage2Greeting = "Liuxu: Welcome!";
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

{
  config,
  lib,
  pkgs,
  ...
}:
{
  here = {
    switch = {
      generate = true;
      default = config.liuxu.nixos.internal.final.internal.user-support.gui.enable;
      description = ''
        Liuxu: Whether to enable the Plymouth, which is boot animation.
          Default enable when enables GUI, but can be enabled seperately.
      '';
    };

    apply = lib.mkIf config.liuxu.nixos.internal.user-support.gui.plymouth.enable {
      boot = {
        consoleLogLevel = 0;
        kernelParams = [
          "quiet"
          "splash"
        ];
        plymouth = {
          enable = true;
          font = "${pkgs.maple-mono.NF-CN-unhinted}/share/fonts/truetype/MapleMono-NF-CN-Regular.ttf";
        };
      };
    };
  };
}

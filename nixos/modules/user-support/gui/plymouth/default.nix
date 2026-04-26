{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.nixos.user-support.gui.plymouth.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.liuxu.nixos.user-support.gui.enable;
    example = false;
    description = ''
      Liuxu: Whether to enable the Plymouth, which is boot animation.
        Default enable when enables GUI, but can be enabled seperately.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.user-support.gui.plymouth.enable {
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
}

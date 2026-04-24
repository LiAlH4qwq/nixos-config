{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.nixos.user-support.gui.intel-graphics.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.liuxu.nixos.user-support.gui.enable;
    example = false;
    description = ''
      Liuxu: Whether to enable the Intel Graphics support.
        Currently enables VAAPI and QSV drivers for Intel graphics cards.
        Takes no effect when GUI is not enabled.
    '';
  };

  config =
    let
      cfgSuper = config.liuxu.nixos.user-support.gui;
      cfgSelf = cfgSuper.intel-graphics;
    in
    lib.mkIf (cfgSuper.enable && cfgSelf.enable) {
      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver # VAAPI
        vpl-gpu-rt # QSV
      ];
    };
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.nixos.user-support.gui.intel-graphics.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.liuxu.nixos.internal.user-support.gui.enable;
    example = false;
    description = ''
      Liuxu: Whether to enable the Intel Graphics support.
        Currently enables VAAPI and QSV drivers for Intel graphics cards.
        Won't be actually enabled when no user has GUI enabled.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.user-support.gui.intel-graphics.enable (
    lib.liuxu.mkIfElse config.liuxu.nixos.internal.user-support.gui.enable
      {
        hardware.graphics.extraPackages = with pkgs; [
          intel-media-driver # VAAPI
          vpl-gpu-rt # QSV
        ];
      }
      {
        warnings = builtins.singleton ''
          Liuxu: Intel Graphics support is enabled,
            which is to support GUI,
            but no user has GUI enabled,
            so it won't be actually enabled.
        '';
      }
  );
}

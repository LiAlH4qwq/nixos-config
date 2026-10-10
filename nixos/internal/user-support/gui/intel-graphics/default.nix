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
        Liuxu: Whether to enable the Intel Graphics support.
          Currently enables VAAPI and QSV drivers for Intel graphics cards.
          Won't be actually enabled when no user has GUI enabled.
      '';
    };

    apply = lib.mkIf config.liuxu.nixos.internal.user-support.gui.intel-graphics.enable (
      lib.liuxu.mkIfElse config.liuxu.nixos.internal.final.internal.user-support.gui.enable
        {
          hardware.graphics.extraPackages = with pkgs; [
            intel-media-driver # VAAPI
            vpl-gpu-rt # QSV
          ];
        }
        {
          warnings = [
            ''
              Liuxu: Intel Graphics support is enabled,
                which is to support GUI,
                but no user has GUI enabled,
                so it won't be actually enabled.
            ''
          ];
        }
    );
  };
}

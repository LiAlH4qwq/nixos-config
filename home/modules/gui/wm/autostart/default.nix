{
  config,
  lib,
  ...
}:
{
  here.option = lib.mkOption {
    internal = true;
    type = with lib.types; listOf (coercedTo str lib.singleton (listOf str));
    default = [ ];
  };

  here.apply = lib.mkIf config.liuxu.home.internal.final.gui.enable {
    liuxu.home.gui.wm.autostart = [
    ];
  };
}

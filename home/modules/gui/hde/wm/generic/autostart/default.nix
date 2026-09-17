{
  config,
  lib,
  ...
}:
{
  options.liuxu.home.gui.wm.autostart = lib.mkOption {
    internal = true;
    type = with lib.types; listOf (coercedTo str lib.singleton (listOf str));
    default = [ ];
  };

  config = lib.mkIf config.liuxu.home.internal.gui.enable {
    liuxu.home.gui.wm.autostart = [
      [
        "1password"
        "--silent"
      ]
    ];
  };
}

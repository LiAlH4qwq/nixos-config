{
  config,
  lib,
  ...
}:
{
  options.liuxu.nixos.internal.user-support.gui.flatpak.enable = lib.mkOption {
    internal = true;
    readOnly = true;
    type = lib.types.bool;
    default =
      config.home-manager.users
      |> builtins.attrValues
      |> map (userCfg: userCfg.liuxu.home.gui.flatpaks != [ ])
      |> lib.any lib.id;
  };

  config = lib.mkIf config.liuxu.nixos.internal.user-support.gui.flatpak.enable {
    services.flatpak.enable = true;
  };
}

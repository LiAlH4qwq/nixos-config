{
  config,
  lib,
  ...
}:
{
  options.liuxu.nixos.internal.user-support.gui.niri.enable =
    lib.liuxu.modules.mkComputedSwitchOption
      (
        config.home-manager.users
        |> builtins.attrValues
        |> map (cfg: cfg.liuxu.home.gui.niri.enable)
        |> builtins.any lib.id
      );

  config = lib.mkIf config.liuxu.nixos.internal.user-support.gui.hyprland.enable {
    programs.niri.enable = true;
  };
}

{ config, lib, ... }:
{
  options.liuxu.nixos.internal.user-support.gui.hyprland.enable =
    lib.liuxu.modules.mkComputedSwitchOption
      (
        config.home-manager.users
        |> builtins.attrValues
        |> map (cfg: cfg.liuxu.home.gui.hyprland.enable)
        |> builtins.any lib.id
      );

  config = lib.mkIf config.liuxu.nixos.internal.user-support.gui.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}

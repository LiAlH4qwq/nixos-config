{ config, lib, ... }:
{
  options.liuxu.nixos.internal.user-support.gui.hyprland.enable = lib.mkOption {
    type = lib.types.bool;
    internal = true;
    readOnly = true;
    default =
      config.home-manager.users
      |> builtins.attrValues
      |> map (cfg: cfg.liuxu.home.gui.hyprland.enable)
      |> builtins.any lib.id;
  };

  config = lib.mkIf config.liuxu.nixos.internal.user-support.gui.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };
}

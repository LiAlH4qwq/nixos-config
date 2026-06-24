{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.nixos.internal.user-support.gui.niri.enable = lib.mkOption {
    type = lib.types.bool;
    internal = true;
    readOnly = true;
    default =
      config.home-manager.users
      |> builtins.attrValues
      |> map (cfg: cfg.liuxu.home.gui.niri.enable)
      |> builtins.any lib.id;
  };

  config = lib.mkIf config.liuxu.nixos.internal.user-support.gui.hyprland.enable {
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };
}

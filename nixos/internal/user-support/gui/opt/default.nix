{ config, lib, ... }: {
  options.liuxu.nixos.internal.user-support.gui.opt.enable = lib.liuxu.mkComputedSwitchOption (
    config.home-manager.users
    |> builtins.attrValues
    |> map (x: x.liuxu.home.internal.final.gui.opt.enable)
    |> builtins.any lib.id
  );

  config = lib.mkIf config.liuxu.nixos.internal.user-support.gui.opt.enable {
    programs.steam.enable = true;
  };
}

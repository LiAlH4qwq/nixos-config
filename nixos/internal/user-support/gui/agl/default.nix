{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.agl.nixosModules.default ];

  options.liuxu.nixos.internal.user-support.gui.agl.enable = lib.liuxu.mkComputedSwitchOption (
    config.home-manager.users
    |> builtins.attrValues
    |> map (userCfg: userCfg.liuxu.home.gui.agl.enable)
    |> lib.any lib.id
  );

  config = lib.mkIf config.liuxu.nixos.internal.user-support.gui.agl.enable {
    networking.mihoyo-telemetry.block = true;
  };
}

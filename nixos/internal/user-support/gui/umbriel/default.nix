{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.umbriel.nixosModules.default ];

  options.liuxu.nixos.internal.user-support.gui.umbriel.enable =
    lib.liuxu.modules.mkComputedSwitchOption
      (
        config.home-manager.users
        |> builtins.attrValues
        |> map (cfg: cfg.liuxu.home.gui.umbriel.enable)
        |> builtins.any lib.id
      );

  config = lib.mkIf config.liuxu.nixos.internal.user-support.gui.umbriel.enable {
    programs.umbriel.enable = true;
  };
}

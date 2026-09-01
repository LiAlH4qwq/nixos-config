{ config, lib, ... }: {
  options.liuxu.nixos.internal.user-support.gui.zen.enable = lib.liuxu.mkComputedSwitchOption (
    config.home-manager.users
    |> builtins.attrValues
    |> map (cfg: cfg.liuxu.home.internal.final.gui.zen.enable)
    |> builtins.any lib.id
  );

  config = lib.mkIf config.liuxu.nixos.internal.user-support.gui.zen.enable {
    environment.etc.zen-1password = {
      target = "1password/custom_allowed_browsers";
      text = "zen";
      # Execute bit required.
      mode = "0755";
    };
  };
}

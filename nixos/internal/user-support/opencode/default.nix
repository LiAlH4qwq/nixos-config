{ config, lib, ... }: {
  options.liuxu.nixos.internal.user-support.opencode.enable = lib.liuxu.mkComputedSwitchOption (
    config.home-manager.users
    |> builtins.attrValues
    |> map (x: x.liuxu.home.opencode.enable)
    |> builtins.any lib.id
  );

  config = lib.mkIf config.liuxu.nixos.internal.user-support.opencode.enable {
    sops.templates."opencode/auth.json" = {
      mode = "0440";
      group = config.users.groups.users.name;
      content =
        builtins.toJSON
        <|
          builtins.mapAttrs
            (_: v: {
              type = "api";
              key = v;
            })
            {
              deepseek = config.sops.placeholder."ai/accessTokens/deepseek";
              kimi-for-coding = config.sops.placeholder."ai/accessTokens/kimi";
              xiaomi-token-plan-cn = config.sops.placeholder."ai/accessTokens/mimo";
            };
    };
  };
}

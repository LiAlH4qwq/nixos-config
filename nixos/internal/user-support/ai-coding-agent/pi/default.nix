{ config, lib, ... }: {
  options.liuxu.nixos.internal.user-support.ai-coding-agent.pi.enable =
    lib.liuxu.mkComputedSwitchOption
      (
        config.home-manager.users
        |> builtins.attrValues
        |> map (x: x.liuxu.home.ai-coding-agent.pi.enable)
        |> builtins.any lib.id
      );

  config = lib.mkIf config.liuxu.nixos.internal.user-support.ai-coding-agent.pi.enable {
    sops.templates."pi-coding-agent/auth.json" = {
      mode = "0440";
      group = config.users.groups.users.name;
      content =
        builtins.toJSON
        <|
          builtins.mapAttrs
            (_: v: {
              type = "api_key";
              key = v;
            })
            {
              deepseek = config.sops.placeholder."ai/accessTokens/deepseek";
              kimi-coding = config.sops.placeholder."ai/accessTokens/kimi";
              commandcode = config.sops.placeholder."ai/accessTokens/command-code";
            };
    };
  };
}

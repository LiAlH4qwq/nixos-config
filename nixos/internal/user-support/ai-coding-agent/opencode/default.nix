{ config, lib, ... }: {
  options.liuxu.nixos.internal.user-support.ai-coding-agent.opencode.enable =
    lib.liuxu.mkComputedSwitchOption
      (
        config.home-manager.users
        |> builtins.attrValues
        |> map (x: x.liuxu.home.ai-coding-agent.opencode.enable)
        |> builtins.any lib.id
      );

  config = lib.mkIf config.liuxu.nixos.internal.user-support.ai-coding-agent.opencode.enable {
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
              command-code = config.sops.placeholder."ai/accessTokens/command-code";
            };
    };
  };
}

{ config, ... }:
{
  here = {
    switch = {
      default = true;
      premise = [
        {
          scope = "home";
          path = [
            "ai-coding-agent"
            "opencode"
          ];
        }
      ];
    };
    config.sops.templates."opencode/auth.json" = {
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

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
            "pi"
          ];
        }
      ];
    };
    config.sops.templates."pi-coding-agent/auth.json" = {
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

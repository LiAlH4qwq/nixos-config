{ config, ... }:
{
  here = {
    switch = {
      generate = true;
      default = true;
      premise = {
        scope = "home";
        path = [
          "ai-coding-agent"
          "opencode"
        ];
      };
    };
    apply = {
      vaultix = {
        secrets = {
          "ai/accessTokens/deepseek" = { };
          "ai/accessTokens/kimi" = { };
          "ai/accessTokens/command-code" = { };
        };
        templates."opencode/auth.json" = {
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
                  deepseek = config.vaultix.placeholder."ai/accessTokens/deepseek";
                  kimi-for-coding = config.vaultix.placeholder."ai/accessTokens/kimi";
                  command-code = config.vaultix.placeholder."ai/accessTokens/command-code";
                };
        };
      };
    };
  };
}

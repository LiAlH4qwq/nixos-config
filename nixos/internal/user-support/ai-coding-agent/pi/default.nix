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
          "pi"
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
        templates."pi-coding-agent/auth.json" = {
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
                  deepseek = config.vaultix.placeholder."ai/accessTokens/deepseek";
                  kimi-coding = config.vaultix.placeholder."ai/accessTokens/kimi";
                  commandcode = config.vaultix.placeholder."ai/accessTokens/command-code";
                };
        };
      };
    };
  };
}

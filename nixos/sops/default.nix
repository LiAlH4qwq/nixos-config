{
  config,
  inputs,
  root,
  ...
}:
{
  imports = [ inputs.sops.nixosModules.default ];

  sops = {
    defaultSopsFile = "${root}/sops/default.yaml";
    age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      "ai/accessTokens/deepseek" = { };
      "ai/accessTokens/kimi" = { };
      "ai/accessTokens/mimo" = { };
      "mihoyo/providerUrls/alink" = { };
      "smartd/bot/target" = { };
      "smartd/bot/token" = { };
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
              deepseek = config.sops.placeholder."ai/accessTokens/deepseek";
              kimi-for-coding = config.sops.placeholder."ai/accessTokens/kimi";
              xiaomi-token-plan-cn = config.sops.placeholder."ai/accessTokens/mimo";
            };
    };
  };
}

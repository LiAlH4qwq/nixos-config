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
  };
}

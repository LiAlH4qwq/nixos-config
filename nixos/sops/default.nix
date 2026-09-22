{
  config,
  inputs,
  lib,
  pkgs,
  root,
  ...
}:
{
  imports = [ inputs.sops.nixosModules.default ];

  options.liuxu.nixos.sops.localMachine = {
    secrets = lib.mkOption {
      type = with lib.types; attrsOf unspecified;
      default = { };
      example."users/lialh4/hashedPassword".neededForUsers = true;
      description = lib.liuxu.mkOsDesc ''
        Local machine secrets,
          `config.liuxu.nixos.sops.localMachine.secrets.<secret>` maps to `config.sops.secrets."localMachine/<secret>"`.
          note: It's a written-only option, for reading, access `config.sops.secrets."localMachine/<secret>"` instead.
      '';
    };
    templates = lib.mkOption {
      type = with lib.types; attrsOf unspecified;
      default = { };
      description = lib.liuxu.mkOsDesc ''
        Local machine templates,
          `config.liuxu.nixos.sops.localMachine.templates.<template>` maps to `config.sops.templates."localMachine/<template>"`.
          note: It's a written-only option, for reading, access `config.sops.secrets."localMachine/<template>"` instead.
      '';
    };
  };

  config = {
    sops = {
      defaultSopsFile = "${root}/sops/default.yaml";
      age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
      secrets = lib.mkMerge [
        {
          "ai/accessTokens/deepseek" = { };
          "ai/accessTokens/kimi" = { };
          "ai/accessTokens/mimo" = { };
          "mihoyo/providerUrls/alink" = { };
          "smartd/bot/target" = { };
          "smartd/bot/token" = { };
        }
        (
          config.liuxu.nixos.sops.localMachine.secrets
          |> lib.mapAttrs' (
            n: v: {
              name = "localMachine/${n}";
              value = lib.mkMerge [
                (removeAttrs v [ "sopsFile" ])
                {
                  sopsFile = "${root}/sops/${config.networking.hostName}.yaml";
                }
              ];
            }
          )
        )
      ];
      templates =
        config.liuxu.nixos.sops.localMachine.templates
        |> lib.mapAttrs' (
          n: v: {
            name = "localMachine/${n}";
            value = v;
          }
        );
    };

    environment.systemPackages = with pkgs; [
      sops
      ssh-to-age
    ];
  };
}

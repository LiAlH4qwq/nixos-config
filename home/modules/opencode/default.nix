{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.liuxu.home.opencode.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu (Home): Whether to enable opencode,
        a coding agent.
    '';
  };

  config = lib.mkIf config.liuxu.home.opencode.enable {
    programs = {
      opencode = {
        enable = true;
        enableMcpIntegration = true;
        settings = {
          autoupdate = false;
          model = "deepseek/deepseek-v4-flash-vision-exp";
        };
      };
      mcp = {
        enable = true;
        servers.nixos.command = lib.getExe <| pkgs.mcp-nixos;
      };
    };

    # FIXME: It's unsafe, since it assume that agenix os module has already installed secrets,
    #   agenix home module should be used instead, so it can safely run after secret installing,
    #   and also benifit from non-hardcoded secret owner,
    #   but it needs pathing secretV2 submodule and I hadn't designed the interface change :(
    systemd.user.services.opencode-secrets = {
      Install.WantedBy = [ "default.target" ];
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart =
          lib.getExe
          <| pkgs.writers.writeNuBin "opencode-secrets" (
            let
              secretPathsShArg =
                osConfig.age.secretsV2.ai.accessToken
                |> lib.mapAttrs' (
                  n: v: {
                    name =
                      if n == "kimi" then
                        "kimi-for-coding"
                      else if n == "mimo" then
                        "xiaomi-token-plan-cn"
                      else
                        n;
                    value = v.path;
                  }
                )
                |> (pkgs.formats.yaml_1_2 { }).generate "opencode-secrets"
                |> lib.escapeShellArg;
            in
            ''
              let secrets = open ${secretPathsShArg} | from yaml | items {|n, v|
                let secret = open $v | str trim
                {
                  ($n): {
                    type: api
                    key: ($secret)
                  }
                }
              } | reduce {|cur, acc| $acc | merge $cur}
              mkdir ~/.local/share/opencode/
              $secrets | save -f ~/.local/share/opencode/auth.json
            ''
          );
      };
    };
  };
}

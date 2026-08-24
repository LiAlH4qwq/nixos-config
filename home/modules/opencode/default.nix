{
  config,
  lib,
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
    programs.opencode = {
      enable = true;
      settings = {
        autoupdate = false;
      };
    };

    # FIXME: It's unsafe, since it assume that agenix os module has already installed secrets,
    #   agenix home module should be used instead, so it can safely run after secret installing,
    #   and also benifit from non-hardcoded secret owner,
    #   but it needs pathing secretV2 submodule and I hadn't designed the interface change :(
    systemd.user.services.opencode-secrets = {
      Install.WantedBy = [ "default.target" ];
      Service.ExecStart =
        lib.getExe
        <| pkgs.writers.writeNuBin "opencode-secrets" ''
          let kimi = open /run/agenix/ai.accessToken.kimi | str trim
          let mimo = open /run/agenix/ai.accessToken.mimo | str trim
          let secrets = {
            kimi-for-coding: {
              type: api
              key: ($kimi)
            }
            xiaomi-token-plan-cn: {
              type: api
              key: ($mimo)
            }
          }
          mkdir ~/.local/share/opencode/
          $secrets | save -f ~/.local/share/opencode/auth.json
        '';
    };
  };
}

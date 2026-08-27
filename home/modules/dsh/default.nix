{
  config,
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  imports = [ inputs.dsh.homeModules.default ];

  options.liuxu.home.dsh.enable = lib.liuxu.mkHomeSwitchOnOption ''
    Whether to enable Deepseek Harness,
      an modular AI coding agent.
  '';

  config = lib.mkIf config.liuxu.home.dsh.enable {
    programs.dsh = {
      enable = true;
      home = "\${HOME}/.local/share/dsh";
      defaultProfile = config.programs.dsh.profiles.web.materializedName;
      profiles.web = {
        bundles = [ pkgs.dsh.bundles.web-app ];
      };
    };
    services.dsh = {
      enable = true;
      extraArguments = [ "--no-open" ];
      environmentFile = "${config.programs.dsh.home}/.env";
    };
    systemd.user.services = {
      dsh-web.Service =
        let
          cfg = config.services.dsh;
          escapeHome = lib.replaceString "\${HOME}" "%h";
        in
        {
          Environment = "DSH_HOME=${cfg.dataDir}";
          EnvironmentFile = cfg.environmentFile;
          WorkingDirectory = lib.mkForce <| escapeHome cfg.workspace;
        };
      dsh-secrets =
        let
          before = [ "dsh-web.service" ];
        in
        {
          Unit.Before = before;
          Install.WantedBy = before;
          Service = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart =
              lib.getExe
              <| pkgs.writers.writeNuBin "dsh-secrets" ''
                let secret = open ${
                  lib.escapeShellArg <| osConfig.age.secretsV2.ai.accessToken.deepseek.path
                } | str trim
                $"DEEPSEEK_API_KEY=($secret)" | save -f ${lib.escapeShellArg <| config.services.dsh.environmentFile}
              '';
          };
        };
    };
    liuxu.home.internal.intransience.dirs = [ ".local/share/dsh" ];
  };
}

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
    systemd.user.services =
      let
        cfg = config.services.dsh;
      in
      {
        dsh-web.Service = builtins.mapAttrs (lib.liuxu.const lib.mkForce) (
          let
            escapeHome = lib.replaceString "\${HOME}" "%h";
          in
          {
            Environment = "DSH_HOME=${escapeHome cfg.dataDir}";
            EnvironmentFile = escapeHome cfg.environmentFile;
            WorkingDirectory = escapeHome cfg.workspace;
          }
        );
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
                <| pkgs.writers.writeNuBin "dsh-secrets" (
                  let
                    escapeHome = lib.liuxu.o lib.escapeShellArg (lib.replaceString "\${HOME}" "~");
                  in
                  ''
                    let secret = open ${
                      lib.escapeShellArg <| osConfig.age.secretsV2.ai.accessToken.deepseek.path
                    } | str trim
                    mkdir ${escapeHome <| config.services.dsh.dataDir}
                    $"DEEPSEEK_API_KEY=($secret)" | save -f ${escapeHome <| config.services.dsh.environmentFile}
                  ''
                );
            };
          };
      };
    liuxu.home.internal.intransience.dirs = [ ".local/share/dsh" ];
  };
}

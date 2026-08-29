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
      # Broken :(
      # home = "$HOME/.local/share/dsh";
      defaultProfile = config.programs.dsh.profiles.web.materializedName;
      profiles.web = {
        bundles = [ pkgs.dsh.bundles.web-ui ];
      };
    };
    services.dsh = {
      enable = true;
      extraArguments = [ "--no-open" ];
      environmentFile = "%h/.cache/dsh/.env";
    };
    systemd.user.services.dsh-secrets =
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
                escapeHome = lib.liuxu.o lib.escapeShellArg (lib.replaceString "%h" "~");
              in
              ''
                let secret = open ${
                  lib.escapeShellArg <| osConfig.age.secretsV2.ai.accessToken.deepseek.path
                } | str trim
                mkdir ~/.cache/dsh/
                echo $"DEEPSEEK_API_KEY=($secret)" | save -f ${escapeHome <| config.services.dsh.environmentFile}
              ''
            );
        };
      };
    liuxu.home.internal.intransience.dirs = [ ".local/share/dsh" ];
  };
}

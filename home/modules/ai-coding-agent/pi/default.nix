{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.liuxu.home.ai-coding-agent.pi.enable =
    lib.liuxu.mkHomeSwitchOnOption "Whether to enable pi coding agent";

  config = lib.mkIf config.liuxu.home.ai-coding-agent.pi.enable {
    home = {
      packages = with pkgs; [ unstable.pi-coding-agent ];
      file = {
        pi-coding-agent-settings = {
          target = ".pi/agent/settings.json";
          text = builtins.toJSON {
            lastChangelogVersion = pkgs.unstable.pi-coding-agent.version;
            packages = map (x: "npm:${x}") (
              (map (x: "pi-${x}") [
                "commandcode-provider"
                "mcp-adapter"
                "open-tui"
                "subagents"
                "web-access"
              ])
              ++ (map (x: "@juicesharp/rpiv-${x}") [
                "ask-user-question"
                "todo"
              ])
              ++ [
                "catppuccin-pi-theme"
                "@narumitw/pi-plan-mode"
              ]
            );
            enableAnalytics = true;
            theme = "catppuccin-latte";
            defaultProvider = "commandcode";
            defaultModel = "deepseek-v4.1-flash";
            enabledModels = [
              "deepseek/deepseek-flash"
              "commandcode/deepseek/deepseek-v4.1-flash"
            ];
          };
        };
      };
    };

    services.opencode-sanitizer.pi-coding-agent.enable = true;

    systemd.user.services.pi-coding-agent-secrets = {
      Install.WantedBy = [ "default.target" ];
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart =
          let
            secrets = osConfig.sops.templates."pi-coding-agent/auth.json".path;
          in
          lib.getExe
          <| pkgs.writers.writeNuBin "pi-coding-agent-secrets" ''
            open -r ${secrets} | save -rf ~/.pi/agent/auth.json
          '';
      };
    };
  };
}

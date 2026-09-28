{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.home.pi-coding-agent.enable =
    lib.liuxu.mkHomeSwitchOnOption "Whether to enable pi coding agent";

  config = lib.mkIf config.liuxu.home.pi-coding-agent.enable {
    home = {
      packages = with pkgs; [ unstable.pi-coding-agent ];
      file.pi-coding-agent-settings = {
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
          defaultProvider = "deepseek";
          defaultModel = "deepseek-v4.1-flash";
        };
      };
    };
  };
}

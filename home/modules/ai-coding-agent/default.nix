{ config, lib, ... }: {
  imports = [
    ./opencode
    ./pi
  ];

  options.liuxu.home.internal.ai-coding-agent.enable = lib.liuxu.mkComputedSwitchOption (
    config.liuxu.home.ai-coding-agent.opencode.enable || config.liuxu.home.ai-coding-agent.pi.enable
  );

  config = lib.mkIf config.liuxu.home.internal.ai-coding-agent.enable {
    services.opencode-sanitizer.settings.rules.tw-flag = {
      pattern = "🇹🇼";
      literal = true;
    };
  };
}

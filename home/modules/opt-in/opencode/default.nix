{ config, lib, ... }: {
  options.liuxu.home.opencode.enable = lib.liuxu.mkHomeSwitchOnOption ''
    Whether to enable opencode,
      a coding agent.
  '';

  config = lib.mkIf config.liuxu.home.opencode.enable {
    programs.opencode = {
      enable = true;
      settings = {
        autoupdate = false;
      };
    };
  };
}

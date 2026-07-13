{ config, lib, ... }: {
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
  };
}

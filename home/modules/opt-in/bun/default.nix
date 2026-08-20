{ config, lib, ... }: {
  options.liuxu.home.bun.enable = lib.liuxu.mkHomeSwitchOnOption ''
    Whether to enable Bun,
      an alternative javascript runtime.
  '';

  config = lib.mkIf config.liuxu.home.bun.enable {
    programs.bun = {
      enable = true;
      settings = {
        run = {
          # Never use node for `bun run`.
          bun = true;
        };
      };
    };
  };
}

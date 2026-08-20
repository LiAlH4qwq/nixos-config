{ pkgs, ... }:
{
  programs = {
    bun = {
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

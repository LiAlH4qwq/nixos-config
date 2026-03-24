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
  # 😭 Biome won't run when installed by bun.
  home.packages = with pkgs; [
    biome
  ];
}

{ pkgs, ... }: {
  programs.npm.enable = true;

  home.packages = with pkgs; [ pnpm ];

  xdg.configFile.pnpm-global-config = {
    target = "pnpm/config.yaml";
    text = builtins.toJSON {
      storeDir = "~/.local/share/pnpm/store";
    };
  };

  liuxu.home.internal.intransience.dirs = [ ".local/share/pnpm/store" ];
}

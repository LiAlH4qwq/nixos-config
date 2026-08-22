{ pkgs, ... }: {
  programs.npm = {
    enable = true;
    package = pkgs.nodejs_latest;
    settings = {
      prefix = "\${HOME}/.local/share/npm";
    };
  };

  xdg.configFile.pnpm-global-config = {
    target = "pnpm/config.yaml";
    text = builtins.toJSON {
      storeDir = "~/.local/share/pnpm/store";
    };
  };

  home.sessionPath = [
    "$HOME/.local/share/npm/bin"
    "$HOME/.local/share/npm/bin/pnpm"
  ];

  liuxu.home.internal.intransience.dirs = [
    ".cache/node/corepack"
    ".local/share/npm"
    ".local/share/pnpm/store"
  ];
}

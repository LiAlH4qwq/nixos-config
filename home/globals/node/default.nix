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
      storeDir = "\${HOME}/.local/share/pnpm/store";
    };
  };

  home.sessionPath = [
    "\${HOME}/.local/share/npm/bin"
  ];

  # Fix non-posix shell don't load path
  programs.nushell.environmentVariables.extraEnv = [
    ''$env.PATH = $env.PATH | prepend [$"($env.HOME)/.local/share/npm/bin"]''
  ];

  liuxu.home.internal.intransience.dirs = [
    ".cache/node/corepack"
    ".local/share/npm"
    ".local/share/pnpm/store"
  ];
}

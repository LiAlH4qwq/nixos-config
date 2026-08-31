{ config, ... }: {
  imports = [ ./gh ];

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = false;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user = {
        name = config.liuxu.home.id.git.name;
        email = config.liuxu.home.id.git.email;
        signingKey = "~/.ssh/id_ed25519.pub";
      };
    };
  };
}

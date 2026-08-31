{ config, lib, ... }: {
  imports = [ ./gh ];

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = false;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user = {
        signingKey = "~/.ssh/id_ed25519.pub";
      }
      // lib.optionalAttrs (config.liuxu.home.id != null) {
        name = config.liuxu.home.id.git.name;
        email = config.liuxu.home.id.git.email;
      };
    };
  };
}

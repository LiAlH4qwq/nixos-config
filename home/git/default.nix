_: {
  imports = [ ./gh ];

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      pull.rebase = false;
      commit.gpgsign = true;
      gpg.format = "ssh";
      user = {
        name = "LiAlH4";
        email = "lialh4qwq@outlook.com";
        signingKey = "~/.ssh/id_ed25519.pub";
      };
    };
  };
}

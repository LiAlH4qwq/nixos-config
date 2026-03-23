_: {
  programs.fish = {
    enable = true;
    loginShellInit = ''
      if uwsm check may-start
        uwsm start default
      end
    '';
    shellAliases = {
      cat = "bat";
      ls = "eza";
      # Fix strange `la = eza -a` misbehavivor.
      la = "eza -la";
    };
  };
}

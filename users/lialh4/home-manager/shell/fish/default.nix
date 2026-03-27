_: {
  programs.fish = {
    enable = true;
    loginShellInit = ''
      if uwsm check may-start
        uwsm start default
      end
    '';
  };
}

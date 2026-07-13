_: {
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      # Keep at least 5 recent generatations
      # and generations within 7days,
      # while enable store optimization.
      extraArgs = "--optimise -k 5 -K 1w";
    };
  };
}

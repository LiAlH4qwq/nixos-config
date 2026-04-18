_: {
  programs.starship = {
    enable = true;
    settings = {
      shell = {
        disabled = false;
        fish_indicator = "󰈺";
        bash_indicator = "";
      };
      shlvl = {
        disabled = false;
        format = "[$symbol]($style)";
        repeat = true;
        symbol = "❯";
        repeat_offset = 1;
      };
    };
  };
}

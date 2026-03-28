_: {
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
    settings = {
      font = {
        size = 12;
      };
      theme = {
        name = "rose-pine-dawn";
      };
    };
  };
}

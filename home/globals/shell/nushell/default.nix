{ pkgs, ... }: {
  programs.nushell = {
    enable = true;
    settings.show_banner = false;
  };

  home.packages = with pkgs; [ nufmt ];

  liuxu.home.internal.preservation.files = [ ".config/nushell/history.txt" ];
}

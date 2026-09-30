{ pkgs, ... }: {
  programs.nushell = {
    enable = true;
    settings.show_banner = false;
    extraConfig = ''
      source ${./completion-menu.nu}
      source ${./fish-completer.nu}
    '';
  };

  home.packages = with pkgs; [ nufmt ];

  liuxu.home.preservation.files = [ ".config/nushell/history.txt" ];
}

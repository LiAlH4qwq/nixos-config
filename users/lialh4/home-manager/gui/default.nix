{ pkgs, ... }:
{
  imports = [
    ./hde
    ./kitty
    ./vscode
  ];

  programs = {
    firefox.enable = true;
  };

  # These programs hasn't been availible as programs config. :(
  home.packages = with pkgs; [
    nautilus # explorer.exe
    mission-center # taskmgr.exe
    lollypop # Music player
    clapper # Video player
    materialgram # Telegram with material design
  ];
}

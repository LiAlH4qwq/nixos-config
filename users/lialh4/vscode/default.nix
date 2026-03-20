{ pkgs, ... }:
{
  home-manager.users.lialh4.programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
    ];
  };
}

{ lib, scopes, ... }:
{
  imports = [
    (lib.nix-tree-modules.mkTree {
      inherit scopes;
      scopeName = "home";
      dir = ./ai-coding-agent;
      base = [ "ai-coding-agent" ];
    })
    (lib.nix-tree-modules.mkTree {
      inherit scopes;
      scopeName = "home";
      dir = ./gui;
      base = [ "gui" ];
    })
    (lib.nix-tree-modules.mkTree {
      inherit scopes;
      scopeName = "home";
      dir = ./sdk;
      base = [ "sdk" ];
    })
  ];
}

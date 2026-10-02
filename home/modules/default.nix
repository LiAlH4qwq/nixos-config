{ lib, scopes, ... }:
{
  imports = [
    (lib.liuxu.mkTree {
      inherit scopes;
      scopeName = "home";
      dir = ./ai-coding-agent;
      base = [ "ai-coding-agent" ];
    })
    (lib.liuxu.mkTree {
      inherit scopes;
      scopeName = "home";
      dir = ./gui;
      base = [ "gui" ];
    })
    (lib.liuxu.mkTree {
      inherit scopes;
      scopeName = "home";
      dir = ./sdk;
      base = [ "sdk" ];
    })
  ];
}

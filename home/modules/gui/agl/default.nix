{ pkgs, ... }:
{
  here = {
    switch.premise = [ "gui" ];
    config = {
      home.packages = with pkgs; [ the-honkers-railway-launcher ];
      liuxu.home.preservation.files = [ ".local/share/honkers-railway-launcher/config.json" ];
    };
  };
}

{ pkgs, ... }:
{
  here = {
    switch = {
      generate = true;
      premise = [ "gui" ];
    };
    apply = {
      home.packages = with pkgs; [ the-honkers-railway-launcher ];
      liuxu.home.preservation.files = [ ".local/share/honkers-railway-launcher/config.json" ];
    };
  };
}

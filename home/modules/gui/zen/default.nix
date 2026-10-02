{
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.zen.homeModules.beta ];

  here = {
    switch = {
      default = true;
      premise = [ "gui" ];
    };
    config = {
      programs.zen-browser = {
        enable = true;
        profiles.default = {
          pinsForce = true;
          pinsForceAction = "remove";
          pins.netease-cloud-music = {
            title = "Netease Cloud Music";
            id = "92a3e3b9-b9f2-4a69-9557-ba12509ac371";
            isEssential = true;
            url = "https://music.163.com/st/webplayer";
          };
        };
      };
      liuxu.home.preservation.directories = [ ".config/zen/default" ];
    };
  };
}

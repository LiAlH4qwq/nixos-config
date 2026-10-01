{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.zen.homeModules.beta ];

  options.liuxu.home = {
    gui.zen.enable = lib.liuxu.mkHomeSwitchOffOption ''
      Whether to enable the Zen browser.
    '';
    internal.final.gui.zen.enable = lib.liuxu.mkComputedSwitchOption (
      config.liuxu.home.internal.gui.enable && config.liuxu.home.gui.zen.enable
    );
  };

  config = lib.mkIf config.liuxu.home.internal.final.gui.zen.enable {
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
}

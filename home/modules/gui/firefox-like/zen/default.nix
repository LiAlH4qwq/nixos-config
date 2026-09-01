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
      profiles.default = { };
    };
    liuxu.home.internal.intransience.dirs = [ ".config/zen/default" ];
  };
}

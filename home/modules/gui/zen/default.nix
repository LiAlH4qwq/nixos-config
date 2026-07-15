{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfgSuper = config.liuxu.home.internal.gui.enable;
in
{
  imports = [ inputs.zen.homeModules.beta ];

  options.liuxu.home.gui.zen.enable = lib.mkOption {
    type = lib.types.bool;
    default = cfgSuper;
    example = false;
    description = ''
      Liuxu (Home): Whether to enable the Zen browser.
    '';
  };

  config = lib.mkIf (cfgSuper && config.liuxu.home.gui.zen.enable) {
    programs.zen-browser = {
      enable = true;
      profiles.default.extensions.packages = with pkgs.firefox-addons; [ onepassword-password-manager ];
    };
  };
}

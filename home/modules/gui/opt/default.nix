{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./vscode ];

  options.liuxu.home = {
    gui.opt.enable = lib.liuxu.mkHomeSwitchOffOption ''
      Whether to enable large gui apps,
        which are often electron things :(
    '';
    internal.final.gui.opt.enable = lib.liuxu.mkComputedSwitchOption (
      config.liuxu.home.internal.gui.enable && config.liuxu.home.gui.opt.enable
    );
  };

  config = lib.mkIf config.liuxu.home.internal.final.gui.opt.enable {
    programs = {
      discord = {
        enable = true;
        settings.SKIP_HOST_UPDATE = true;
      };
      obs-studio.enable = true;
    };
    home.packages = with pkgs; [
      bottles
      inkscape
      qq
      wechat
      wemeet
      wpsoffice-cn
    ];

    liuxu.home.internal.intransience.dirs = [
      # discord
      ".config/discord"

      # obs-studio
      ".config/obs-studio"

      # steam
      ".steam"
      ".local/share/Steam"

      # bottles
      ".local/share/bottles"

      # qq
      ".config/QQ"

      # wechat
      ".xwechat"
      "xwechat_files"

      # wpsoffice-cn
      ".config/Kingsoft"
      ".local/share/Kingsoft"
    ];
  };
}

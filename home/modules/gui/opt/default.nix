{ pkgs, ... }:
{
  here = {
    switch = {
      default = true;
      premise = [ "gui" ];
    };
    config = {
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

      liuxu.home.preservation.directories = [
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
  };
}

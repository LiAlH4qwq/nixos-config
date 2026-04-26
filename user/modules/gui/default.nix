{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  imports = [
    ./hde
    ./kitty
    ./vscode
  ];

  options.liuxu.user.gui.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu (User): Whether to enable GUI.
        Provides a full functional Hyprland Desktop Environment
    '';
  };

  config = lib.mkIf config.liuxu.user.gui.enable {
    assertions = [
      {
        assertion = osConfig.liuxu.nixos.user-support.gui.enable;
        message = "liuxu.system.user-support.gui.enable in system configuration should be set to true in order to enable GUI for user!";
      }
    ];

    programs = {
      firefox.enable = true;
      obs-studio.enable = true;
      discord = {
        enable = true;
        settings = {
          SKIP_HOST_UPDATE = true;
        };
      };
      ssh = {
        enable = true;
        # See: https://mynixos.com/home-manager/option/programs.ssh.enableDefaultConfig
        enableDefaultConfig = false;
        matchBlocks."*".identityAgent = "~/.1password/agent.sock";
      };
    };

    home = {
      sessionVariables = {
        "NIXOS_OZONE_WL" = 1;
      };
      # These programs hasn't been availible as programs config. :(
      packages = with pkgs; [
        nautilus # explorer.exe
        mission-center # taskmgr.exe
        lollypop # Music player
        clapper # Video player
        wev # Input inspect
        inkscape
        materialgram # Telegram with material design
        qq
        wechat
        wemeet
        wpsoffice-cn
      ];
    };
  };
}

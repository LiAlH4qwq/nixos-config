{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.nixos.user-support.gui.display-manager.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.liuxu.nixos.user-support.gui.enable;
    example = false;
    description = ''
      Liuxu: Whether to enable the Display Manager.
        Can't be enabled without enabling GUI!
    '';
  };

  config = lib.mkIf config.liuxu.nixos.user-support.gui.display-manager.enable {
    assertions = [
      {
        assertion = config.liuxu.nixos.user-support.gui.enable;
        message = "Display Manager can't be enabled without enabling GUI!";
      }
    ];

    programs.regreet = {
      enable = true;
      settings = {
        application_prefer_dark_theme = false;
        background = {
          fit = "Cover";
          path = "/etc/wallpapers/rainy-everything-in-the-night.png";
        };
        widget.clock.format = "%a %d %b %H:%M";
      };
      font = {
        size = 14;
        name = "Noto Sans CJK SC";
        package = pkgs.noto-fonts-cjk-sans;
      };
      theme = {
        name = "rose-pine-dawn";
        package = pkgs.rose-pine-gtk-theme;
      };
      iconTheme = {
        name = "rose-pine-dawn";
        package = pkgs.rose-pine-icon-theme;
      };
      cursorTheme = {
        name = "BreezeX-RosePineDawn-Linux";
        package = pkgs.rose-pine-cursor;
      };
    };

    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings = {
        default_session = {
          command = "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.hyprland} -c /etc/greetd/hyprland.conf > /dev/null 2>&1";
        };
      };
    };

    systemd.tmpfiles.settings.regreet."/etc/greetd/hyprland.conf".f = {
      argument = ''
        exec-once = ${lib.getExe pkgs.regreet}; hyprctl dispatch exit
        env = GTK_USE_PORTAL,0
        env = GDK_DEBUG,no-portals
        env = XCURSOR_THEME, BreezeX-RosePineDawn-Linux
        misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
          disable_hyprland_guiutils_check = true
        }
      '';
    };

    intransience.datastores.persist.files = [ "/var/lib/regreet/state.toml" ];
  };
}

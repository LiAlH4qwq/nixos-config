{ config, lib, ... }:
{
  options.liuxu.system.pin.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    example = false;
    description = ''
      Liuxu: Whether to enable the Windows-Like PIN code support,
        which uses an alter simple password for local auth,
        currently for tty-login, dm-login, hyprlock and polkit(run0 and etc.).
    '';
  };

  config = lib.mkIf config.liuxu.system.pin.enable {
    libpam-pwdfile-rs = {
      pin = {
        pwdfile = "/etc/pin";
        services = [
          "login"
          "polkit-1"
        ]
        ++ lib.optional config.liuxu.system.user-support.gui.enable "hyprlock"
        ++ lib.optional config.liuxu.system.user-support.gui.display-manager.enable "greetd";
      };
    };
  };
}

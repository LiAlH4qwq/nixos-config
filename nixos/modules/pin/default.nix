{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.libpam-pwdfile-rs.nixosModules.default ];

  options.liuxu.nixos.pin.enable = lib.liuxu.modules.mkLiuxuSwitchOffOption ''
    Whether to enable the Windows-Like PIN code support,
      which uses an alter simple password for local auth,
      currently for tty-login, dm-login and polkit(run0 and etc.).
  '';

  config = lib.mkIf config.liuxu.nixos.pin.enable {
    libpam-pwdfile-rs = {
      pin = {
        services = [
          "login"
          "sudo"
          "sudo-i"
          "polkit-1"
        ]
        ++ lib.optional config.liuxu.nixos.user-support.gui.display-manager.enable "greetd";
      };
    };
  };
}

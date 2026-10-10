{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.libpam-pwdfile-rs.nixosModules.default ];

  here = {
    switch = {
      generate = true;
      default = true;
    };
    apply.services.libpam-pwdfile-rs = {
      enable = true;
      instances.pin.pamServices = [
        "login"
        "sudo"
        "sudo-i"
        "polkit-1"
      ]
      ++ lib.optional config.liuxu.nixos.internal.user-support.gui.display-manager.enable "greetd";
    };
  };
}

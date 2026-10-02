{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.libpam-pwdfile-rs.nixosModules.default ];

  here = {
    switch.default = true;
    config.services.libpam-pwdfile-rs = {
      enable = true;
      instances.pin.pamServices = [
        "login"
        "sudo"
        "sudo-i"
        "polkit-1"
      ]
      ++ lib.optional config.liuxu.nixos.user-support.gui.display-manager.enable "greetd";
    };
  };
}

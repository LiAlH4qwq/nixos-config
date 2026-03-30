{ config, lib, ... }:
{
  options.liuxu.system.ssh.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable the SSH access.
        Attention please: It will open firewall port!
          Do not use weak password!!!
    '';
  };

  config = lib.mkIf config.liuxu.system.ssh.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
    };

    # Why default settings enable fprint auth for it?
    security.pam.services.sshd.fprintAuth = false;
  };
}

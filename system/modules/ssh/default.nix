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

  config = {
    # Agenix depends on sshd, so it couldn't be fully disabled.
    services.openssh = {
      enable = true;
      # Disable RSA.
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      openFirewall = config.liuxu.system.ssh.enable;
    };

    # Why default settings enable fprint auth for it?
    security.pam.services.sshd.fprintAuth = false;

    environment.persistence."/persist" = {
      files = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };
  };
}

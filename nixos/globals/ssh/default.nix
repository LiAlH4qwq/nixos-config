{ lib, pkgs, ... }: {
  imports = [
    (lib.mkAliasOptionModule [ "liuxu" "nixos" "ssh" "ports" ] [ "services" "openssh" "ports" ])
  ];

  services.openssh = {
    # sops depends on sshd, so it couldn't be fully disabled.
    enable = true;
    settings = {
      # No password login
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    # Disable RSA.
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  systemd.services.ssh-host-pubkey =
    let
      before = [ "sshd.service" ];
    in
    {
      inherit before;
      wantedBy = before;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.openssh}/bin/ssh-keygen -y \
          -f /etc/ssh/ssh_host_ed25519_key \
          > /etc/ssh/ssh_host_ed25519_key.pub
        chmod 644 /etc/ssh/ssh_host_ed25519_key.pub
      '';
    };
}

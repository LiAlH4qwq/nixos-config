_: {
  services.openssh = {
    # agenix depends on sshd, so it couldn't be fully disabled.
    enable = true;
    # Disable RSA.
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };
}

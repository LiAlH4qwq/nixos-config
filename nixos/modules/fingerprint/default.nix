_: {
  here.config = {
    services.fprintd = {
      enable = true;
    };
    # Make enrolled fingerprints persistent.
    preservation.preserveAt.persist.directories = [ "/var/lib/fprint" ];
    # Why default settings enable fprint auth for it?
    security.pam.services.sshd.fprintAuth = false;
  };
}

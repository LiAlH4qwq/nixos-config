_: {
  imports = [ ./bash-less ];

  # Mutable users are meaningless,
  # when using tmpfs-as-root.
  users.mutableUsers = false;

  system = {
    # It needs perl and almost unused,
    # since most hardware settings work out of box.
    tools.nixos-generate-config.enable = false;
    # Get rid of perl script that generate /etc.
    etc.overlay = {
      enable = true;
      # mutable = false;
    };
  };

  # Get rid of perl script that generate users registry.
  services.userborn = {
    enable = true;
    passwordFilesLocation = "/persist/var/lib/userborn";
  };
}

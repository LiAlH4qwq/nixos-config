_: {
  here.config = {
    users = {
      users.builder = {
        isSystemUser = true;
        useDefaultShell = true;
        group = "builder";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILMBJTE2mzCoOzL7ajBjgtjNixnyslgvAhBcwnjSFmeK"
        ];
      };
      groups.builder = { };
    };

    nix.settings.trusted-users = [ "builder" ];
  };
}

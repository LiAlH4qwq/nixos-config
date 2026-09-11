{ config, lib, ... }: {
  options.liuxu.nixos.builder.enable = lib.liuxu.mkOsSwitchOnOption ''
    Whether make this machine a Nix remote builder.
  '';

  config = lib.mkIf config.liuxu.nixos.builder.enable {
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

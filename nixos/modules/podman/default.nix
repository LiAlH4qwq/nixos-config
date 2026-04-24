{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.nixos.podman.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable Podman,
        a container management tool,
        drop-in replacement of docker.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.podman.enable {
    virtualisation = {
      containers.enable = true;
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        # allow communication between containers.
        defaultNetwork.settings.dns_enabled = true;
      };
    };
    environment.systemPackages = with pkgs; [
      podman-compose
    ];
  };
}

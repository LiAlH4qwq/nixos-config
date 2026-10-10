{ pkgs, ... }:
{
  here = {
    switch.generate = true;
    apply = {
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
  };
}

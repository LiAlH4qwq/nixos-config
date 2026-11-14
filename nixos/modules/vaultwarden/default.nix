{ config, lib, ... }:
{
  here = {
    switch.generate = true;
    apply = {
      services = {
        vaultwarden = {
          enable = true;
          environmentFile = config.vaultix.templates."vaultwarden/credentials".path;
          config = {
            ROCKET_PORT = 8222;
            SIGNUPS_ALLOWED = false;
            INVITATIONS_ALLOWED = false;
            SHOW_PASSWORD_HINT = false;
          };
        };
      };
      liuxu.nixos.caddy = {
        enable = true;
        virtualHosts.vaultwarden = {
          hostName = "vaultwarden.lialh4.cyou";
          extraConfig = ''
            reverse_proxy :${config.services.vaultwarden.config.ROCKET_PORT} {
              header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}
            }
          '';
        };
      };
      preservation.preserveAt.persist.directories = [
        {
          directory = "/var/lib/vaultwarden";
          user = "vaultwarden";
          group = "vaultwarden";
        }
      ];
      vaultix = {
        secrets."vaultwarden/adminToken" = { };
        templates."vaultwarden/credentials" = {
          owner = config.users.users.vaultwarden.name;
          group = config.users.users.vaultwarden.group;
          content = "ADMIN_TOKEN=${config.vaultix.placeholder."vaultwarden/adminToken"}";
        };
      };
      systemd.services.vaultwarden.restartTriggers = [
        config.vaultix.secrets."vaultwarden/adminToken".file
      ];
    };
  };
}

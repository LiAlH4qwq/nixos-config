{ config, lib, ... }: {
  options.liuxu.nixos.vaultwarden = {
    enable = lib.liuxu.mkOsSwitchOnOption ''
      Whether to enable vaultwarden,
        rust impl of bitwarden server.
    '';
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 443;
      example = 8443;
      description = lib.liuxu.mkOsDesc "Port for vaultwarden.";
    };
  };

  config = lib.mkIf config.liuxu.nixos.vaultwarden.enable {
    services = {
      vaultwarden = {
        enable = true;
        environmentFile = config.sops.templates."vaultwarden/credentials".path;
        config = {
          ROCKET_PORT = 8222;
          SIGNUPS_ALLOWED = false;
          INVITATIONS_ALLOWED = false;
          SHOW_PASSWORD_HINT = false;
        };
      };
      caddy = {
        enable = true;
        httpsPort = config.liuxu.nixos.vaultwarden.port;
        virtualHosts.vaultwarden = {
          hostName = "vaultwarden.lialh4.cyou";
          extraConfig = ''
            encode zstd gzip
            tls /etc/${config.environment.etc.lialh4-cyou-pem.target} ${
              config.sops.secrets."tlsCert/keys/lialh4.cyou.pem.key".path
            }
            reverse_proxy :${config.services.vaultwarden.config.ROCKET_PORT} {
              header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}
            }
          '';
        };
      };
    };
    environment.etc.lialh4-cyou-pem = {
      target = "tlsCerts/lialh4.cyou.pem";
      text = ''
        -----BEGIN CERTIFICATE-----
        MIIDIjCCAsigAwIBAgIUHVUPrBsKG28q2ZCRhf5fZKGmyYowCgYIKoZIzj0EAwIw
        gY8xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1T
        YW4gRnJhbmNpc2NvMRkwFwYDVQQKExBDbG91ZEZsYXJlLCBJbmMuMTgwNgYDVQQL
        Ey9DbG91ZEZsYXJlIE9yaWdpbiBTU0wgRUNDIENlcnRpZmljYXRlIEF1dGhvcml0
        eTAeFw0yNjA5MTEwMDQ3MDBaFw00MTA5MDcwMDQ3MDBaMGIxGTAXBgNVBAoTEENs
        b3VkRmxhcmUsIEluYy4xHTAbBgNVBAsTFENsb3VkRmxhcmUgT3JpZ2luIENBMSYw
        JAYDVQQDEx1DbG91ZEZsYXJlIE9yaWdpbiBDZXJ0aWZpY2F0ZTBZMBMGByqGSM49
        AgEGCCqGSM49AwEHA0IABNcE/UOHGX+S4YxOgCHP9xpnfr+y76zh5Ak02B/LXriK
        FQnQJYcHUreAVo2XyCZKj8Od0AL8MEfOAChSaxv8vXGjggEsMIIBKDAOBgNVHQ8B
        Af8EBAMCBaAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMBMAwGA1UdEwEB
        /wQCMAAwHQYDVR0OBBYEFGn+XyNNC7deox+uIjyvko8gfh1KMB8GA1UdIwQYMBaA
        FIUwXTsqcNTt1ZJnB/3rObQaDjinMEQGCCsGAQUFBwEBBDgwNjA0BggrBgEFBQcw
        AYYoaHR0cDovL29jc3AuY2xvdWRmbGFyZS5jb20vb3JpZ2luX2VjY19jYTAlBgNV
        HREEHjAcgg0qLmxpYWxoNC5jeW91ggtsaWFsaDQuY3lvdTA8BgNVHR8ENTAzMDGg
        L6AthitodHRwOi8vY3JsLmNsb3VkZmxhcmUuY29tL29yaWdpbl9lY2NfY2EuY3Js
        MAoGCCqGSM49BAMCA0gAMEUCIQCIyfTbUY/RZsqBV9eDybYuUScM2p8nb/L/fJkG
        J80bmgIgazY1o2XYMf/GYw4p6XiMV8Fx5dxahuS+z5h4P8jiXxI=
        -----END CERTIFICATE-----
      '';
    };
    intransience.datastores.persist.dirs = [
      {
        path = "/var/lib/vaultwarden";
        user = "vaultwarden";
        group = "vaultwarden";
      }
    ];
    sops = {
      secrets = {
        "tlsCert/keys/lialh4.cyou.pem.key" = {
          owner = config.users.users.caddy.name;
          group = config.users.users.caddy.group;
        };
        "vaultwarden/adminToken" = { };
      };
      templates."vaultwarden/credentials" = {
        owner = config.users.users.vaultwarden.name;
        group = config.users.users.vaultwarden.group;
        restartUnits = [ "vaultwarden.service" ];
        content = "ADMIN_TOKEN=${config.sops.placeholder."vaultwarden/adminToken"}";
      };
    };
  };
}

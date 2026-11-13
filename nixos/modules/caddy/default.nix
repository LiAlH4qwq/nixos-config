{ config, lib, ... }:
{
  here = {
    switch.generate = true;
    options =
      let
        desc = lib.liuxu.mkOsDesc;
      in
      {
        port = lib.mkOption {
          type = lib.types.ints.u16;
          default = 443;
          example = 8443;
          description = desc ''
            HTTPS port served by Caddy.
          '';
        };
        virtualHosts = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                hostName = lib.mkOption {
                  type = lib.types.singleLineStr;
                  example = "example.com";
                  description = desc ''
                    Canonical hostname of the virtual host.
                  '';
                };
                serverAliases = lib.mkOption {
                  type = lib.types.listOf lib.types.singleLineStr;
                  default = [ ];
                  example = [ "www.example.com" ];
                  description = desc ''
                    Additional hostnames served by the virtual host.
                  '';
                };
                extraConfig = lib.mkOption {
                  type = lib.types.lines;
                  default = "";
                  example = ''
                    reverse_proxy 127.0.0.1:8080
                  '';
                  description = desc ''
                    Extra Caddyfile directives for the virtual host.
                  '';
                };
              };
            }
          );
          default = { };
          description = desc ''
            Virtual hosts served by Caddy.
          '';
        };
      };
    apply =
      let
        cfg = config.liuxu.nixos.caddy;
        certTarget = "tlsCerts/lialh4.cyou.pem";
        certFile = "/etc/${certTarget}";
        keyFile = config.sops.secrets."tlsCert/keys/lialh4.cyou.pem.key".path;
      in
      {
        services.caddy = {
          enable = true;
          httpsPort = cfg.port;
          virtualHosts = builtins.mapAttrs (_: vhost: {
            inherit (vhost) hostName serverAliases;
            extraConfig = ''
              encode zstd gzip
              tls ${certFile} ${keyFile}
              ${vhost.extraConfig}
            '';
          }) cfg.virtualHosts;
        };
        environment.etc.lialh4-cyou-pem = {
          target = certTarget;
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
        sops.secrets."tlsCert/keys/lialh4.cyou.pem.key" = {
          owner = config.users.users.caddy.name;
          group = config.users.users.caddy.group;
        };
      };
  };
}

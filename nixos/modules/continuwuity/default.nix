{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.liuxu.nixos.continuwuity;
  serverName = cfg.settings.global.server_name;
  matrixHost = "matrix.${serverName}";
  matrixPort = builtins.head cfg.settings.global.port;
  cinny = pkgs.cinny.override {
    conf = {
      defaultHomeserver = 0;
      homeserverList = [ matrixHost ];
      allowCustomHomeservers = true;
    };
  };
in
{
  imports = [
    (lib.mkAliasOptionModule
      [
        "liuxu"
        "nixos"
        "continuwuity"
      ]
      [
        "services"
        "matrix-continuwuity"
      ]
    )
  ];

  here = { };

  config = lib.mkIf cfg.enable {
    services.matrix-continuwuity.package = lib.mkDefault pkgs.matrix-continuwuity_latest;
    liuxu.nixos.caddy = {
      enable = true;
      virtualHosts.continuwuity = {
        hostName = matrixHost;
        extraConfig = ''
          @matrix path /_matrix/* /_continuwuity/* /.well-known/matrix/*
          handle @matrix {
            reverse_proxy 127.0.0.1:${toString matrixPort} {
              header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}
              header_up X-Forwarded-Proto {scheme}
            }
          }
          handle {
            root * ${cinny}
            try_files {path} /index.html
            file_server
          }
        '';
      };
    };
    preservation.preserveAt.persist.directories = [
      {
        directory = "/var/lib/private/continuwuity";
        inherit (cfg) user group;
        mode = "0700";
        parent.mode = "0700";
      }
    ];
  };
}

{
  config,
  lib,
  ...
}:
let
  cfg = config.liuxu.nixos.misskey;

  host = lib.head (
    lib.splitString "/" (lib.removePrefix "https://" (lib.removePrefix "http://" cfg.settings.url))
  );
in
{
  imports = [
    (lib.mkAliasOptionModule
      [
        "liuxu"
        "nixos"
        "misskey"
      ]
      [
        "services"
        "misskey"
      ]
    )
  ];

  here = { };

  config = lib.mkIf cfg.enable {
    services.misskey.settings.address = lib.mkDefault "127.0.0.1";

    liuxu.nixos.caddy = {
      enable = true;
      virtualHosts.misskey = {
        hostName = host;
        extraConfig = ''
          reverse_proxy 127.0.0.1:${toString cfg.settings.port} {
            header_up X-Forwarded-For {http.request.header.CF-Connecting-IP}
            header_up X-Forwarded-Proto {scheme}
          }
        '';
      };
    };

    users.users.misskey = {
      isSystemUser = true;
      group = "misskey";
      home = "/var/lib/misskey";
    };
    users.groups.misskey = { };

    users.users.meilisearch = lib.mkIf cfg.meilisearch.createLocally {
      isSystemUser = true;
      group = "meilisearch";
      home = "/var/lib/meilisearch";
    };
    users.groups.meilisearch = lib.mkIf cfg.meilisearch.createLocally { };

    systemd.services.meilisearch.serviceConfig = lib.mkIf cfg.meilisearch.createLocally {
      User = "meilisearch";
      Group = "meilisearch";
    };

    preservation.preserveAt.persist.directories = [
      {
        directory = "/var/lib/private/misskey";
        user = "misskey";
        group = "misskey";
        mode = "0700";
        parent.mode = "0700";
      }
    ]
    ++ lib.optionals cfg.database.createLocally [
      {
        directory = "/var/lib/postgresql";
        user = "postgres";
        group = "postgres";
        mode = "0700";
      }
    ]
    ++ lib.optionals cfg.redis.createLocally [
      {
        directory = "/var/lib/redis-misskey";
        user = "redis-misskey";
        group = "redis-misskey";
        mode = "0700";
      }
    ]
    ++ lib.optionals cfg.meilisearch.createLocally [
      {
        directory = "/var/lib/private/meilisearch";
        user = "meilisearch";
        group = "meilisearch";
        mode = "0700";
        parent.mode = "0700";
      }
    ];
  };
}

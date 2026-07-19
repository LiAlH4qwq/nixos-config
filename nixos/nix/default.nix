{ lib, ... }:
{
  imports = [
    ./nixos
  ];

  nix = {
    settings =
      let
        admins = [
          "root"
          "@wheel"
        ];
      in
      {
        allowed-users = admins;
        trusted-users = admins;
      };
  };
  intransience.datastores.persist.files = lib.singleton "/root/.local/share/nix/trusted-settings.json";
}

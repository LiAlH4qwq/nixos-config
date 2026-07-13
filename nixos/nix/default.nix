{ lib, self, ... }:
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
        substituters = self.nixConfig.extra-substituters;
        trusted-public-keys = self.nixConfig.extra-trusted-public-keys;
        experimental-features = [
          "flakes"
          "nix-command"
          "pipe-operator"
        ];
        allowed-users = admins;
        trusted-users = admins;
      };
  };
  intransience.datastores.persist.files = lib.singleton "/root/.local/share/nix/trusted-settings.json";
}

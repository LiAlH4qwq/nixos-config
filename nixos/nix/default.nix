{ lib, ... }:
{
  imports = [
    ./lix
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
        auto-allocate-uids = true;
        builders-use-substitutes = true;
        http3 = true;
        use-cgroups = true;
        use-xdg-base-directories = true;
      };
  };
  intransience.datastores.persist.files = lib.singleton "/root/.local/share/nix/trusted-settings.json";
}

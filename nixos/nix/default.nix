{ lib, self, ... }:
{
  imports = [
    ./nixos
  ];

  nix =
    let
      commonOpions = {
        automatic = true;
        # Don't miss out due to poweroff.
        persistent = true;
        randomizedDelaySec = "1h";
        dates = [
          "17:30"
        ];
      };
    in
    {
      optimise = {
        inherit (commonOpions)
          automatic
          persistent
          randomizedDelaySec
          dates
          ;
      };
      gc = {
        inherit (commonOpions)
          automatic
          persistent
          randomizedDelaySec
          dates
          ;
        options = "--delete-older-than 7d";
      };
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
          extra-deprecated-features = [ "url-literals" ];
          allowed-users = admins;
          trusted-users = admins;
        };
    };
  intransience.datastores.persist.files = lib.singleton "/root/.local/share/nix/trusted-settings.json";
}

_: {
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
      gc = {
        inherit (commonOpions)
          automatic
          persistent
          randomizedDelaySec
          dates
          ;
        options = "--delete-older-than 7d";
      };
    };
}

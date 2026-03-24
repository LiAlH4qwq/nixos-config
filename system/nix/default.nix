_: {
  nix =
    let
      commonOpions = {
        automatic = true;
        # Don't miss out due to poweroff.
        persistent = true;
        randomizedDelaySec = "1h";
        dates = [
          "17.30"
        ];
      };
    in
    {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      gc = {
        inherit (commonOpions)
          automatic
          persistent
          randomizedDelaySec
          dates
          ;
        options = "--delete-older-than 7d";
      };
      optimise = {
        inherit (commonOpions)
          automatic
          persistent
          randomizedDelaySec
          dates
          ;
      };
    };
  # We won't sacrifice our experience for FOSS.
  nixpkgs.config.allowUnfree = true;
}

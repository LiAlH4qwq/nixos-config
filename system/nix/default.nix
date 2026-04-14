_: {
  imports = [
    ./lix
    ./nixos
  ];

  # We won't sacrifice our experience for FOSS.
  nixpkgs.config.allowUnfree = true;
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
      settings =
        let
          admins = [
            "root"
            "@wheel"
          ];
        in
        {
          experimental-features = [
            "flakes"
            "nix-command"
            "pipe-operator"
          ];
          allowed-users = admins;
          trusted-users = admins;
          substituters = [
            "https://mirrors.nju.edu.cn/nix-channels/store?priority=24"
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
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
      optimise = {
        inherit (commonOpions)
          automatic
          persistent
          randomizedDelaySec
          dates
          ;
      };
    };
}

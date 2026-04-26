_: {
  imports = [
    ./lix
  ];

  # We won't sacrifice our experience for FOSS.
  nixpkgs.config.allowUnfree = true;
  nix.settings =
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
      extra-deprecated-features = [ "url-literals" ];
      allowed-users = admins;
      trusted-users = admins;
      substituters = [
        "https://mirrors.nju.edu.cn/nix-channels/store?priority=24"
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://noctalia.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };
}

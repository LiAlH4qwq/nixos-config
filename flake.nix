{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations.LiAlH4-Nix = nixpkgs.lib.nixosSystem {
      modules = [
        home-manager.nixosModules.default
        ./default.nix
      ];
    };
  };
}


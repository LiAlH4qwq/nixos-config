{
  description = "nix-tree-modules: a strict tree of switchable NixOS-style modules (the `here` DSL)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    {
      lib = import ./src { lib = nixpkgs.lib; };
    };
}

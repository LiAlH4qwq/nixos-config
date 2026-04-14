{ inputs, ... }:
{
  imports = [
    ./nixos-cli
  ];

  environment.etc.nixos = {
    source = "${inputs.self}";
  };
}

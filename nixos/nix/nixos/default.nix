{ inputs, ... }:
{
  imports = [
    ./nh
  ];

  environment.etc.nixos = {
    source = "${inputs.self}";
  };
}

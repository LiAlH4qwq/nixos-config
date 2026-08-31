{ root, ... }:
{
  imports = [
    ./nh
  ];

  environment.etc.nixos = {
    source = "${root}";
  };
}

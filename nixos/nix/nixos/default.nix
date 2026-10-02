{ root, ... }:
{
  environment.etc.nixos = {
    source = "${root}";
  };
}

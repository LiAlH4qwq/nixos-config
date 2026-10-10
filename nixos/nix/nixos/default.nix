{ root, ... }:
{
  here = { };
  environment.etc.nixos = {
    source = "${root}";
  };
}

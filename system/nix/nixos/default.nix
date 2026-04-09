{ inputs, ... }:
{
  environment.etc.nixos = {
    source = "${inputs.self}";
  };
}

{ inputs, ... }:
{
  imports = [
    "${inputs.self}/system"
    ./boot
    ./modules
  ];
}

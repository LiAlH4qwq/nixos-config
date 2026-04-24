{ inputs, ... }:
{
  imports = [
    "${inputs.self}/system"
    ./proot
  ];
}

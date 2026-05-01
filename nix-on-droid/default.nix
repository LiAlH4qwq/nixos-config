{
  inputs,
  ...
}:
{
  imports = [
    "${inputs.self}/system"
    ./nixos-shim
    ./proot
  ];
}

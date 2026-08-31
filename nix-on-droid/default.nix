{
  root,
  ...
}:
{
  imports = [
    (root + "/system")
    ./nixos-shim
    ./proot
  ];
}

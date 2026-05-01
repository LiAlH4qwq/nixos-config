{ lib, ... }:
{
  imports = [
    lib.mkAliasOptionModule
    [
      "environment"
      "systemPackages"
    ]
    [
      "environment"
      "packages"
    ]
  ];
}

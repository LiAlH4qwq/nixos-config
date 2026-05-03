{ lib, self, ... }:
{
  flake.lib = import "${self}/lib" { inherit lib; };
}

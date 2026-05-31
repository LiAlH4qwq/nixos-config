{ lib, ... }:
let
  dir = "/var/lib/userborn";
in
{
  services.userborn = {
    enable = true;
    passwordFilesLocation = dir;
  };
  intransience.datastores.persist.dirs = lib.singleton dir;
}

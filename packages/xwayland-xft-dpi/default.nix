{
  writers,
  pkgs,
  lib,
  xrdb,
}:
writers.writeNuBin "xwayland-xft-dpi" (
  pkgs.replaceVars ./xwayland-xft-dpi.nu {
    xrdb = lib.getExe xrdb;
  }
)

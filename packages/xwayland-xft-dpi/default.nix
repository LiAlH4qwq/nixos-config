{
  writers,
  lib,
  xrdb,
}:
writers.writeNuBin "xwayland-xft-dpi" {
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      xrdb
    ])
  ];
} ./xwayland-xft-dpi.nu

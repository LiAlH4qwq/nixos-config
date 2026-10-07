{
  fetchurl,
  stdenv,
  unzip,
}:
let
  sources = import ./sources.nix { inherit fetchurl; };
in
stdenv.mkDerivation {
  pname = "waydroid-lineage-vanilla";
  inherit (sources) version;

  srcs = [
    sources.system
    sources.vendor
  ];

  nativeBuildInputs = [ unzip ];

  # The archives contain only top-level files (system.img / vendor.img), so the
  # generic builder would otherwise fail to detect a source root.
  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 system.img "$out/share/waydroid/images/system.img"
    install -Dm644 vendor.img "$out/share/waydroid/images/vendor.img"
    runHook postInstall
  '';

  passthru.updateScript = ./update.nu;

  meta = {
    description = "Latest VANILLA LineageOS Waydroid system and vendor images (x86_64)";
    platforms = [ "x86_64-linux" ];
  };
}

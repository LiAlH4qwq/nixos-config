{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  ninja,
  perl,
  pkg-config,
  sqlite,
}:
let
  src = fetchFromGitHub {
    owner = "soulsteads";
    repo = "soulsteads-agent-messaging";
    rev = "8b04f14feecc8f099d85146b7767d1ec17d46374";
    hash = "sha256-ggRww0X6KA4GfOsDdZKZzD4WLlKvgNuz1TXrB9es/0g=";
  };
in
rustPlatform.buildRustPackage {
  pname = "soulsteads-messaging";
  version = "0.3.0";

  inherit src;

  cargoLock.lockFile = "${src}/Cargo.lock";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "platform-sdks"
    "matrix-encryption"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    perl
    pkg-config
  ];

  buildInputs = [ sqlite ];

  preBuild = ''
    unset AWS_LC_SYS_USE_SYSTEM
  '';

  dontUseNinjaBuild = true;
  dontUseNinjaCheck = true;
  dontUseNinjaInstall = true;
  doCheck = false;

  meta = {
    description = "Rust messaging bridge for coding agents (ACP)";
    homepage = "https://github.com/soulsteads/soulsteads-agent-messaging";
    license = lib.licenses.asl20;
    mainProgram = "soulsteads-messaging";
    platforms = lib.platforms.linux;
  };
}

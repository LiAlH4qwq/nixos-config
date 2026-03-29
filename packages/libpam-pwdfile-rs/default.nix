{
  fetchFromGitHub,
  lib,
  pam,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libpam-pwdfile-rs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Supernovatux";
    repo = "libpam-pwdfile-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dB722iQvhYvYp+9ItWey0MZmrunSWAHBYYCKsB1R+eg=";
  };

  cargoHash = "sha256-Cu9otmJL0Q5j1HxygEGOJ3ywGT+M1Zn56bYw58JVe08=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pam
  ];

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail \
      '[package]' \
      '[package]
      edition = "2024"'
  '';

  doCheck = false;

  dontCargoInstall = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 \
      target/${stdenv.hostPlatform.config}/release/libpam_pwdfile_rs.so \
      $out/lib/security/pam_pwdfile_rs.so
    runHook postInstall
  '';

  meta = {
    description = "PAM module that allows you to authenticate against a password file";
    longDescription = ''
      This is a rust port of libpam-pwdfile.
      It is a PAM module that allows you to authenticate against a password file.
      Passwords should be hashed with sha512sum.
      This module is useful if you want to authenticate with a password different from the one you use to login to your system.
      For example, if you want to use different password for SDDM and sudo.
      You can also use this module to provide multiple passwords for a single user. 
    '';
    homepage = "https://github.com/Supernovatux/libpam-pwdfile-rs";
    changelog = "https://github.com/Supernovatux/libpam-pwdfile-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})

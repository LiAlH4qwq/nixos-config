{ fetchFromGitHub, stdenv }:
stdenv.mkDerivation {
  pname = "nushell-skill";
  version = "unreleased-2026-07-19";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nu_scripts";
    rev = "8311fa45e8c9d3f467fd668c7338f3e9390404bf";
    hash = "sha256-uH3l/wwiUP2kDJe1GE9vKlkTRYG3fnaspCrDEfgeMYI=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/share/nushell-skill/skills/nushell"
    cp -rT "$src/skills/nushell" "$out/share/nushell-skill/skills/nushell"
  '';
}

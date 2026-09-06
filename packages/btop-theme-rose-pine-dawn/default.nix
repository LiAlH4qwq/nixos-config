{ fetchFromGitHub, stdenv }:
stdenv.mkDerivation {
  pname = "btop-theme-rose-pine-dawn";
  version = "unreleased-2023-06-06";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "btop";
    rev = "fdb859b066343cc1accacc0c2f2c75f1c9e8be59";
    hash = "sha256-Jeqc3N1Othz3AnzQgRg7tt2fX6vL89Efye41Qamvxcg=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/share/btop/themes"
    cp "$src/rose-pine-dawn.theme" "$out/share/btop/themes/rose-pine-dawn-theme"
  '';
}

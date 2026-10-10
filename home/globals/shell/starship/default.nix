{ osConfig, ... }:
let
  osCfg = osConfig.programs.starship;
in
{
  here = { };
  programs.starship = {
    inherit (osCfg) enable settings;
  };
}

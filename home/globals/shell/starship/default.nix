{ osConfig, ... }:
let
  osCfg = osConfig.programs.starship;
in
{
  programs.starship = {
    inherit (osCfg) enable settings;
  };
}

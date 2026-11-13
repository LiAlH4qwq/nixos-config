{ osConfig, ... }:
{
  here = { };
  programs.starship = {
    inherit (osConfig.programs.starship) enable settings;
  };
}

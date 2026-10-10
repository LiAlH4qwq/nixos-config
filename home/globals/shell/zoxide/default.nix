{ osConfig, ... }: {
  here = { };
  programs.zoxide = {
    inherit (osConfig.programs.zoxide) enable;
  };
}

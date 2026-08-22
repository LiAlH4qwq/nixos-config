{ osConfig, ... }: {
  programs.zoxide = {
    inherit (osConfig.programs.zoxide) enable;
  };
}

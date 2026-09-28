{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.home = {
    internal.final.sdk.rust.enable = lib.liuxu.mkComputedSwitchOption (
      config.liuxu.home.sdk.enable && config.liuxu.home.sdk.rust.enable
    );
    sdk.rust.enable = lib.liuxu.mkHomeSwitchOffOption ''
      Whether to enable the Rust SDK.
    '';
  };

  config = lib.mkIf config.liuxu.home.internal.final.sdk.rust.enable {
    programs.cargo.enable = true;
  };
}

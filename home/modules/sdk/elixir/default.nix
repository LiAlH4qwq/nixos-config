{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.home.sdk.elixir.enable =
    lib.liuxu.modules.mkHomeSwitchOption config.liuxu.home.sdk.enable ''
      Whether to enable the Elixir SDK.
    '';

  config = lib.mkIf config.liuxu.home.sdk.elixir.enable {
    assertions = [
      {
        assertion = config.liuxu.home.sdk.enable;
        message = ''
          Liuxu (Home): Elixir SDK can't be enabled without SDKS.
        '';
      }
    ];

    home.packages = with pkgs; [ elixir ];
  };
}

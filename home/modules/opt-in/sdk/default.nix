{ lib, ... }: {
  imports = [ ./elixir ];

  options.liuxu.home.sdk.enable = lib.liuxu.modules.mkHomeSwitchOnOption ''
    Whether to enable the SDKs.
  '';
}

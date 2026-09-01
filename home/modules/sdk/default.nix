{ lib, ... }: {
  imports = [ ./elixir ];

  options.liuxu.home.sdk.enable = lib.liuxu.mkHomeSwitchOnOption ''
    Whether to enable the SDKs.
  '';
}

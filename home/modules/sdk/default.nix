{ lib, ... }: {
  imports = [ ./rust ];

  options.liuxu.home.sdk.enable = lib.liuxu.mkHomeSwitchOnOption ''
    Whether to enable the SDKs.
  '';
}

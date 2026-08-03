{ config, lib, ... }:
{
  options.liuxu.nixos.laptop.enable = lib.liuxu.modules.mkOsSwitchOnOption ''
    Whether to enable the laptop support.
      Currently enables UPower that handles battery usage,
      but lid events are handled by loginctl.
  '';

  config = lib.mkIf config.liuxu.nixos.laptop.enable {
    services.upower = {
      enable = true;
      # Let loginctl handles lid events.
      ignoreLid = true;
    };
  };
}

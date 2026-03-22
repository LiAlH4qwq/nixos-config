{ config, lib, ... }:
{
  options.liuxu.system.laptop.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable the laptop support.
        Currently enables UPower that handles battery usage,
        but lid events are handled by loginctl.
    '';
  };

  config = lib.mkIf config.liuxu.system.laptop.enable {
    services.upower = {
      enable = true;
      # Let loginctl handles lid events.
      ignoreLid = true;
    };
  };
}

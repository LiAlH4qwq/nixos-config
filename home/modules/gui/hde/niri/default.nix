{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.niri-nix.homeModules.default
    ./bind
    ./gesture
    ./wrule
  ];

  options.liuxu.home.gui.niri.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu (Home): Whether to enable the Niri GUI.
    '';
  };

  config = lib.mkIf config.liuxu.home.gui.niri.enable {
    wayland.windowManager.niri = {
      enable = true;
      settings = {
        xwayland-satellite.path = "${pkgs.xwayland-satellite-unstable}/bin/xwayland-satellite";
        prefer-no-csd = [ ];
        hotkey-overlay.skip-at-startup = [ ];
        layout.gaps = 0;
        input = {
          disable-power-key-handling = [ ];
          touchpad = {
            tap = [ ];
            natural-scroll = [ ];
          };
        };
      };
    };
  };
}

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
      extraConfig = lib.kdl.formats.v1 (
        with lib.kdl.extras.niri;
        [
          (xwayland-satellite [
            (path "${pkgs.xwayland-satellite-unstable}/bin/xwayland-satellite")
          ])
          prefer-no-csd
          (hotkey-overlay [ skip-at-startup ])
          (layout [ empty-workspace-above-first ])
          (overview [ (backdrop-color "#faf4ed") ])
          (input [
            disable-power-key-handling
            (touchpad [
              tap
              natural-scroll
            ])
          ])
        ]
      );
    };
  };
}

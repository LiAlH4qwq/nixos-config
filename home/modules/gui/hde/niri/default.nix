{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./bind
    ./wrule
  ];

  options.liuxu.home.gui.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Liuxu (Home): Whether to enable the Niri GUI.
      '';
    };
    settings = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = lib.kdl.formats.v1 (with lib.kdl.extras.niri; [ (input [ disable-power-key-handling ]) ]);
      description = ''
        Liuxu (Home): Niri settings in kdl.
      '';
    };
  };

  config = lib.mkIf config.liuxu.home.gui.niri.enable {
    xdg.configFile.niri-settings = {
      target = "niri/config.kdl";
      text = config.liuxu.home.gui.niri.settings;
    };
    liuxu.home.gui.niri.settings = lib.kdl.formats.v1 (
      with lib.kdl.extras.niri;
      [
        (xwayland-satellite [
          (path "${pkgs.xwayland-satellite}/bin/xwayland-satellite")
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
}

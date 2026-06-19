{ config, lib, ... }: {
  options.liuxu.home.gui.niri.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu (Home): Whether to enable the Niri GUI.
    '';
  };
}

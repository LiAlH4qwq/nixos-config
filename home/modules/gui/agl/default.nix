{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.home.gui.agl.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu (Home): Whether to enable the agl.
    '';
  };

  config = lib.mkIf config.liuxu.home.gui.agl.enable {
    assertions = [
      {
        assertion = config.liuxu.home.internal.gui.enable;
        message = ''
          Liuxu (Home): The agl can't be enabled without gui.
        '';
      }
    ];

    home.packages = with pkgs; [ the-honkers-railway-launcher ];
    liuxu.home.internal.intransience.files = [ ".local/share/honkers-railway-launcher/config.json" ];
  };
}

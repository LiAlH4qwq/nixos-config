{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.flatpak.homeManagerModules.nix-flatpak ];

  options.liuxu.home.gui.flatpaks = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    example = [ "com.tencent.wemeet" ];
    description = ''
      Liuxu (Home): Flatpak apps to install.
    '';
  };

  config = lib.mkMerge [
    (lib.mkIf config.liuxu.home.internal.gui.enable {
      liuxu.home.gui.flatpaks = [
        "com.qq.QQ"
        "com.tencent.wemeet"
      ];
    })
    (
      let
        cfg = config.liuxu.home.gui.flatpaks;
      in
      lib.mkIf (cfg != [ ]) {
        services.flatpak = {
          enable = true;
          uninstallUnmanaged = true;
          packages = cfg;
        };
        liuxu.home.internal.intransience.dirs = [
          ".local/share/flatpak"
          ".var/app"
        ];
      }
    )
  ];
}

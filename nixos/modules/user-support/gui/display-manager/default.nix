{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];
  options.liuxu.nixos.user-support.gui.display-manager.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.liuxu.nixos.internal.user-support.gui.enable;
    example = false;
    description = ''
      Liuxu: Whether to enable Display Manager.
        Won't be actually enabled if no user has GUI enabled.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.user-support.gui.display-manager.enable (
    lib.liuxu.modules.mkIfElse config.liuxu.nixos.internal.user-support.gui.enable
      {
        programs.noctalia-greeter = {
          enable = true;
          package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
          settings.cursor = {
            theme = "BreezeX-RosePineDawn-Linux";
            package = pkgs.rose-pine-cursor;
          };
        };
        # When sync styles from noctalia shell,
        # it will try to remove previous wallpaper file,
        # so the whole dir needs persist.
        # Besides, the state and config share same file,
        # so it can only be treated as state file.
        intransience.datastores.persist.dirs = lib.singleton {
          path = "/var/lib/noctalia-greeter";
          user = "greeter";
        };
      }
      {
        warnings = lib.singleton ''
          Liuxu: Display Manager is enabled,
            which is for logining to GUI easilier,
            but no user has enabled GUI,
            Display Manager won't have any effect,
            so it won't be actually enabled.
        '';
      }
  );
}

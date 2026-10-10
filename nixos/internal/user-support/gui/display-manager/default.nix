{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  here = {
    switch = {
      generate = true;
      default = config.liuxu.nixos.internal.final.internal.user-support.gui.enable;
      description = ''
        Liuxu: Whether to enable Display Manager.
          Won't be actually enabled if no user has GUI enabled.
      '';
    };

    apply = lib.mkIf config.liuxu.nixos.internal.user-support.gui.display-manager.enable (
      lib.liuxu.mkIfElse config.liuxu.nixos.internal.final.internal.user-support.gui.enable
        {
          services.displayManager.noctalia-greeter = {
            enable = true;
            package = pkgs.unstable.noctalia-greeter;
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
          preservation.preserveAt.persist.directories = lib.singleton {
            directory = "/var/lib/noctalia-greeter";
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
  };
}

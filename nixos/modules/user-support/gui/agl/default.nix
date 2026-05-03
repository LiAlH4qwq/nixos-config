{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.agl.nixosModules.default ];

  options.liuxu.nixos.user-support.gui.agl.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable The AGL,
        [404 Not Found].
        Won't be installed if no user has GUI enabled.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.user-support.gui.agl.enable (
    lib.liuxu.mkIfElse config.liuxu.nixos.internal.user-support.gui.enable
      {
        nix.settings = inputs.agl.nixConfig;
        # 😭 It doesn't support *** now.
        # programs.anime-games-launcher.enable = true;
        programs.honkers-railway-launcher.enable = true;
      }
      {
        warnings = builtins.singleton ''
          Liuxu: AGL is a GUI program and is enabled,
            but no user has GUI enabled,
            AGL won't have any effect,
            so it won't be installed.
        '';
      }
  );
}

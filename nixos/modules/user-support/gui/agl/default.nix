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
      Liuxu: Whether to enable the agl,
        [404 Not Found].
    '';
  };

  config = lib.mkIf config.liuxu.nixos.user-support.gui.agl.enable {
    assertions = [
      {
        assertion = config.liuxu.nixos.user-support.gui.enable;
        message = "The agl can't be enabled without enabling GUI!";
      }
    ];

    nix.settings = inputs.agl.nixConfig;
    # 😭 It doesn't support *** now.
    # programs.anime-games-launcher.enable = true;
    programs.honkers-railway-launcher.enable = true;
  };
}

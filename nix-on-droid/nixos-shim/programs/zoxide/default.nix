{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.zoxide =
    let
      desc = lib.liuxu.mkDroidDesc;
    in
    {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = desc ''
          Ported from NixOS options.
        '';
      };
      enableBashIntegration = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = desc ''
          Ported from NixOS options.
        '';
      };
      enableFishIntegration = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = desc ''
          Ported from NixOS options.
        '';
      };
    };

  config = lib.mkIf config.programs.zoxide.enable {
    environment.systemPackages = with pkgs; [ zoxide ];
    programs = {
      bash = lib.mkIf config.programs.zoxide.enableBashIntegration { };
    };
  };
}

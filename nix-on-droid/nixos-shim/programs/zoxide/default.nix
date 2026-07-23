{ config, lib, ... }: {
  options.programs.zoxide = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Liuxu (Droid): Ported from NixOS options.
      '';
    };
    enableBashIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Liuxu (Droid): Ported from NixOS options.
      '';
    };
    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Liuxu (Droid): Ported from NixOS options.
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

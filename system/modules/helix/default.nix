{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.system.helix.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    example = false;
    description = ''
      Whether to enable helix,
        a modern cli text editor.
    '';
  };

  config = lib.mkIf config.liuxu.system.helix.enable {
    environment.systemPackages = with pkgs; [
      helix
    ];
  };
}

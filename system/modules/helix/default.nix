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
    environment = {
      systemPackages = with pkgs; [
        helix
      ];
      etc = {
        helix = {
          target = "helix/config.toml";
          # TOML strings should be quoted.
          text = lib.generators.toINIWithGlobalSection { } {
            globalSection = {
              theme = "\"github_light_colorblind\"";
            };
          };
        };
      };
    };
    programs.fish.shellAliases.hx = "hx -c /etc/helix/config.toml";
  };
}

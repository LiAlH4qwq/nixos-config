{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.system.helix.enable = lib.liuxu.modules.mkLiuxuSwitchOffOption ''
    Whether to enable helix,
      a modern cli text editor.
  '';

  config =
    let
      cmd = "hx -c /etc/helix/config.toml";
    in
    lib.mkIf config.liuxu.system.helix.enable {
      environment = {
        systemPackages = with pkgs; [
          helix
        ];
        sessionVariables = {
          EDITOR = cmd;
        };
        etc = {
          helix = {
            target = "helix/config.toml";
            source =
              let
                mkToml = pkgs.formats.toml { } |> (x: x.generate "");
              in
              mkToml {
                theme = "github_light_colorblind";
              };
          };
        };
      };
      programs.fish.shellAliases.hx = cmd;
    };
}

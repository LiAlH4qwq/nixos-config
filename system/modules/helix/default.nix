{ pkgs, ... }:
{
  here = {
    switch = {
      generate = true;
      default = true;
    };

    apply =
      let
        cmd = "hx -c /etc/helix/config.toml";
      in
      {
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
  };
}

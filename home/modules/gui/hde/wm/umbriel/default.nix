{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.umbriel.homeModules.default ];

  options.liuxu.home.gui.umbriel.enable = lib.liuxu.mkHomeSwitchOnOption ''
    Whether to enable umbriel window manager,
      wm from noctalia, is it gnome?
  '';

  config = lib.mkIf config.liuxu.home.gui.umbriel.enable {
    programs.umbriel = {
      enable = true;
      settings = {
        input =
          let
            pointing = {
              natural_scroll = true;
            };
          in
          {
            mouse = pointing;
            touchpad = pointing;
          };
        keybinds = {
          "Mod+Q" = "window-close";
        };
      };
    };
  };
}

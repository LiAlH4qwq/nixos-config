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
          "Mod+Equal" = "window-modify-width:0.05";
          "Mod+Minus" = "window-modify-width:-0.05";
          "Mod+M" = "window-set-width:1";
          "Mod+F" = "window-toggle-floating";
        };
      };
    };
  };
}

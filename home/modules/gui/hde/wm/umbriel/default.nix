{
  config,
  inputs,
  lib,
  pkgs,
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
        general = {
          show_cheatsheet = false;
          autostart = [ (lib.getExe pkgs.disable-dwt-in-hsr) ];
        };
        workspaces.empty_above = true;
        keybinds = {
          "Mod+Equal" = "window-modify-width:0.05";
          "Mod+Minus" = "window-modify-width:-0.05";
          "Mod+M" = "window-set-width:1";
          "Mod+F" = "window-toggle-floating";
        };
        # Optional import still unsupported in this version.
        include.files = [ "~/.config/umbriel/disable-dwt-in-hsr.toml" ];
      };
    };
    systemd.user.tmpfiles.rules = [ "f %h/.config/umbriel/disable-dwt-in-hsr.toml - - - - -" ];
  };
}

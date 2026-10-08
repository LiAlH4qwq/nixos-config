{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.umbriel.homeModules.default ];

  here.config = {
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
          autostart = [
            (lib.getExe pkgs.disable-dwt-in-hsr)
            (lib.getExe pkgs.xwayland-xft-dpi)
          ];
        };
        workspaces.empty_above = true;
        window_rule = [
          {
            # The Waydroid toplevel is created by the container's HWC service
            # and never requests activation, so Umbriel would otherwise place
            # it off-screen without scrolling to it.
            match.app_id = "^Waydroid$";
            default_focused = true;
          }
        ];
        keybinds = {
          "Mod+Equal" = "window-modify-width-right:0.05";
          "Mod+Minus" = "window-modify-width-right:-0.05";
          "Mod+M" = "window-toggle-maximize";
          "Mod+F" = "window-toggle-floating";
        };
        # Optional import still unsupported in this version.
        include.optional.files = [ "~/.config/umbriel/disable-dwt-in-hsr.toml" ];
      };
    };
  };
}

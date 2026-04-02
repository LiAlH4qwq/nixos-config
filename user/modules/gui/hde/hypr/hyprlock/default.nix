{
  config,
  lib,
  osConfig,
  ...
}:
{
  config = lib.mkIf config.liuxu.user.gui.enable {
    programs.hyprlock = {
      enable = true;
      settings =
        let
          # Rose Pine Dawn Theme
          # Source: https://rosepinetheme.com/palette/
          colors = {
            base = "0xfffaf4ed";
            surface = "0xfffffaf3";
            love = "0xffb4637a";
            text = "0xff575279";
          };
        in
        {
          auth.fingerprint = lib.mkIf osConfig.liuxu.system.fingerprint.enable {
            # Typo? No, there's absolutely no typo.
            enabled = true;
          };
          bezier = [ "linear, 1, 1, 0, 0" ];
          animation = [ "fade, 1, 10, linear" ];
          background = [
            {
              blur_passes = 3;
              # Fallback background color.
              color = colors.base;
              path = "~/Pictures/Wallpapers/rainy-everything-in-the-night.png";
            }
          ];
          label = [
            # Time
            {
              font_size = 128;
              color = "0xffffffff";
              position = "0, 30%";
              text = "$TIME";
              # text = "cmd[update:1000] date +%H:%M";
            }
            # Date
            {
              font_size = 32;
              color = "0xffffffff";
              position = "0, 36%";
              text = "cmd[update:1000] date +%A,\\ %B\\ %d";
            }
            # Username
            {
              font_size = 32;
              color = "0xffffffff";
              position = "0, -3%";
              text = "$USER";
            }
            # Hint
            {
              font_size = 24;
              color = "0xffffffff";
              position = "0, -18%";
              text = "cmd[update:0] echo Or scan fingerprint...\\n$FPRINTFAIL";
              # text = "cmd[update:0] /etc/profiles/per-user/$USER/bin/bun ~/.config/hypr/hyprlock/hint.ts FPRINTFAIL=\\\"$FPRINTFAIL\\\"";
            }
            # Hitokoto
            {
              font_size = 24;
              color = "0xffffffff";
              position = "0, -30%";
              text = "cmd[update:0] /etc/profiles/per-user/$USER/bin/bun ~/.config/hypr/hyprlock/hitokoto.ts";
            }
          ];
          # Avatar
          image = [
            {
              size = 300;
              border_size = 0;
              shadow_passes = 3;
              position = "0, 10%";
              path = "~/Pictures/Avatar.jpg";
            }
          ];
          input-field = [
            {
              fade_on_empty = false;
              shadow_passes = 3;
              position = "0, -12%";
              size = "500, 90";
              inner_color = colors.surface;
              outer_color = colors.surface;
              fail_color = colors.love;
              placeholder_text = "Input password...";
              fail_text = "Please try again...";
            }
          ];
        };
    };
    xdg.configFile = {
      # hyprlock-hint = {
      #   force = true;
      #   source = ./hint.ts;
      #   target = "hypr/hyprlock/hint.ts";
      # };
      hyprlock-hitokoto = {
        force = true;
        source = ./hitokoto.ts;
        target = "hypr/hyprlock/hitokoto.ts";
      };
    };
  };
}

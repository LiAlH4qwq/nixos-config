{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.liuxu.user.gui.enable {
    programs.hyprlock = {
      enable = false;
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
          auth.fingerprint = lib.mkIf osConfig.liuxu.nixos.fingerprint.enable {
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
              path = "/etc/wallpapers/rainy-everything-in-the-night.png";
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
            # Hitokoto
            {
              font_size = 24;
              color = "0xffffffff";
              position = "0, -30%";
              text = "cmd[update:0] ${pkgs.hitokoto}/bin/hitokoto";
            }
          ]
          # Fingerprint Hint
          ++ lib.optional osConfig.liuxu.nixos.fingerprint.enable {
            font_size = 24;
            color = "0xffffffff";
            position = "0, -18%";
            text = ''cmd[update:0] ${pkgs.hyprlock-hint}/bin/hyprlock-hint --user "$USER" --user-desc "$DESC" --kb-layout "$LAYOUT" --auth-fail-num "$ATTEMPTS" --auth-fail-msg "$FAIL" --auth-pam-prompt-msg "$PAMPROMPT" --auth-pam-fail-msg "$PAMFAIL" --auth-fprint-prompt-msg "$FPRINTPROMPT" --auth-fprint-fail-msg "$FPRINTFAIL"'';
          };
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
              placeholder_text = "$PAMPROMPT";
              fail_text = "$PAMFAIL";
            }
          ];
        };
    };
  };
}

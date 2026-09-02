{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./zen ];

  config = lib.mkIf config.liuxu.home.internal.gui.enable (
    let
      cpSettings = {
        search = {
          force = true;
          default = "ddg";
          engines =
            let
              flake-icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            in
            {
              nixos-packages = {
                name = "NixOS Packages";
                definedAliases = [
                  "@pkg"
                  "@pkgs"
                  "@nixpkgs"
                  "@pack"
                  "@packs"
                  "@package"
                  "@packages"
                ];
                icon = flake-icon;
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      (lib.nameValuePair "query" "{searchTerms}")
                    ];
                  }
                ];
              };
              nixos-options = {
                name = "NixOS Options";
                definedAliases = [
                  "@os"
                  "@nixos"
                  "@system"
                ];
                icon = flake-icon;
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      (lib.nameValuePair "type" "options")
                      (lib.nameValuePair "query" "{searchTerms}")
                    ];
                  }
                ];

              };
              home-manager-options = {
                name = "Home Manager Options";
                definedAliases = [ "@home" ];
                icon = flake-icon;
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      (lib.nameValuePair "type" "options")
                      (lib.nameValuePair "source" "home_manager")
                      (lib.nameValuePair "query" "{searchTerms}")
                    ];
                  }
                ];
              };
              noogle = {
                name = "Noogle";
                definedAliases = [ "@noogle" ];
                icon = flake-icon;
                urls = [
                  {
                    template = "https://noogle.dev/q";
                    params = [ (lib.nameValuePair "term" "{searchTerms}") ];
                  }
                ];
              };
              bilibili = {
                name = "Bilibili";
                definedAliases = [
                  "@bili"
                  "@bilibili"
                ];
                icon = "https://www.bilibili.com/favicon.ico";
                urls = [
                  {
                    template = "https://search.bilibili.com/all";
                    params = [ (lib.nameValuePair "keyword" "{searchTerms}") ];
                  }
                ];
              };
            };
        };
        extensions.packages = with pkgs.firefox-addons; [ onepassword-password-manager ];
      };
    in
    {
      programs = {
        firefox = {
          enable = true;
          # 26.05's default, to suppress warning when state version is 25.11.
          configPath = "${config.xdg.configHome}/mozilla/firefox";
          profiles.default = cpSettings;
        };
        zen-browser.profiles.default = lib.mkIf config.liuxu.home.internal.final.gui.zen.enable cpSettings;
      };
      liuxu.home.internal.intransience.dirs = [ ".config/mozilla/firefox/default" ];
    }
  );
}

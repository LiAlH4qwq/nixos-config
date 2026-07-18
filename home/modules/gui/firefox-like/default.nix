{ config, lib, ... }: {
  imports = [ ./zen ];

  config = lib.mkIf config.liuxu.home.internal.gui.enable (
    let
      searchSettings = {
        force = true;
        default = "ddg";
        engines = {
          nixos-packages = {
            name = "NixOS Packages";
            definedAliases = [ "@pack" ];
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
            definedAliases = [ "@os" ];
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
        };
      };
    in
    {
      programs = {
        firefox = {
          enable = true;
          # 26.05's default, to suppress warning when state version is 25.11.
          configPath = "${config.xdg.configHome}/mozilla/firefox";
          profiles.default.search = searchSettings;
        };
        zen-browser.profiles.default.search = lib.mkIf config.liuxu.home.gui.zen.enable searchSettings;
      };
      liuxu.home.internal.intransience.dirs = [ ".config/mozilla/firefox/default" ];
    }
  );
}

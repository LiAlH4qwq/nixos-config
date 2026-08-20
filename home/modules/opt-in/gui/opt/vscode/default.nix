{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.liuxu.home.internal.final.gui.opt.enable {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;
      profiles = {
        # It's wired but it's definately global settings.
        default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
        };
        default = {
          extensions = with pkgs.vscode-extensions; [
            eamodio.gitlens
            seatonjiang.gitmoji-vscode
            redhat.vscode-yaml
            jnoortheen.nix-ide
            biomejs.biome
          ];
          userSettings = {
            "workbench.secondarySideBar.defaultVisibility" = "hidden"; # No copilot
            "workbench.colorTheme" = "Default Light Modern";
            "workbench.tree.indent" = 16;
            "workbench.tree.renderIndentGuides" = "always";
            "window.zoomLevel" = 0.25;
            "editor.formatOnSave" = true;
            "editor.formatOnPaste" = true;
            "editor.fontFamily" = ''"Maple Mono NF CN", monospace'';
            "editor.fontSize" = 16;
            "editor.fontLigatures" = true;
            "terminal.integrated.fontLigatures.enabled" = true;
            "git.suggestSmartCommit" = false;
            "git.enableSmartCommit" = true;
            "git.smartCommitChanges" = "all";
            "git.confirmSync" = false;
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nixd";
            "[typescript]" = {
              "editor.defaultFormatter" = "biomejs.biome";
            };
            "[json]" = {
              "editor.defaultFormatter" = "biomejs.biome";
            };
            # Biome rearrange imports.
            # Source: https://biomejs.dev/reference/vscode/#import-sorting
            # Why did it belongs to `assist` but not `formatter`?
            "editor.codeActionsOnSave" = {
              "source.organizeImports.biome" = "explicit";
            };
            # Fix Biome binary not found
            "biome.lsp.bin" = "${pkgs.biome}/bin/biome";
          };
        };
      };
    };
    liuxu.home.internal.intransience.dirs = [
      ".config/Code"
    ];
  };
}

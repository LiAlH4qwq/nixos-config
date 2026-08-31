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
        default = {
          # It's wired but it's definately global settings.
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;

          extensions = with pkgs.vscode-extensions; [
            biomejs.biome
            eamodio.gitlens
            redhat.vscode-yaml
            seatonjiang.gitmoji-vscode
            jnoortheen.nix-ide
          ];

          userSettings = {
            # Fix Biome binary not found
            "biome.lsp.bin" = "${pkgs.biome}/bin/biome";

            "editor.fontFamily" = ''"Maple Mono NF CN", monospace'';
            "editor.fontLigatures" = true;
            "editor.formatOnPaste" = true;
            "editor.formatOnSave" = true;

            "git.confirmSync" = false;
            "git.enableSmartCommit" = true;
            "git.smartCommitChanges" = "all";
            "git.suggestSmartCommit" = false;

            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nixd";

            "terminal.integrated.cursorStyle" = "line";
            "terminal.integrated.fontLigatures.enabled" = true;

            "window.zoomLevel" = 0.375;

            "workbench.colorTheme" = "Light Modern";
            "workbench.secondarySideBar.defaultVisibility" = "hidden"; # No copilot
            "workbench.tree.indent" = 24;
            "workbench.tree.renderIndentGuides" = "always";

            "[json]" = {
              "editor.defaultFormatter" = "biomejs.biome";
            };

            "[typescript]" = {
              "editor.defaultFormatter" = "biomejs.biome";
            };

            # Biome rearrange imports.
            # Source: https://biomejs.dev/reference/vscode/#import-sorting
            # Why did it belongs to `assist` but not `formatter`?
            "editor.codeActionsOnSave" = {
              "source.organizeImports.biome" = "explicit";
            };

            # Vscode try to save these...
            "json.schemaDownload.trustedDomains" =
              [
                "biomejs.dev"
                "developer.microsoft.com/json-schemas/"
                "json-schema.org/"
                "json.schemastore.org/"
                "raw.githubusercontent.com/devcontainers/spec/"
                "raw.githubusercontent.com/microsoft/vscode/"
                "schemastore.azurewebsites.net/"
                "www.schemastore.org/"
              ]
              |> map (x: "https://${x}")
              |> lib.flip lib.nameValuePair true
              |> builtins.listToAttrs;
          };
        };
      };
    };
    liuxu.home.internal.intransience.dirs = [
      ".config/Code"
    ];
  };
}

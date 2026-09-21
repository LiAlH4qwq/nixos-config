{ lib, osConfig, ... }:
{
  options.liuxu.home.preservation = {
    directories = lib.mkOption {
      type = with lib.types; listOf unspecified;
      default = [ ];
      example = [ "Downloads" ];
      description = lib.liuxu.mkHomeDesc ''
        Directories to persist,
          will be merged to `osConfig.preservation.preserveAt.persist.users.<user>.directories`.
      '';
    };
    files = lib.mkOption {
      type = with lib.types; listOf unspecified;
      default = [ ];
      example = [ ".ssh/known_hosts" ];
      description = lib.liuxu.mkHomeDesc ''
        Files to persist,
          will be merged to `osConfig.preservation.preserveAt.persist.users.<user>.files`.
      '';
    };
  };

  config.liuxu.home.preservation = {
    directories = [
      "Documents"
      "Downloads"
      "Pictures"
      "Videos"

      ".android" # ADB
      ".local/state/syncthing" # Syncthing
    ]
    ++ lib.optionals osConfig.liuxu.system.better-shell.enable [
      # Zoxide
      # Whole dir needs persist,
      # since there will be temp files.
      {
        directory = ".local/share/zoxide";
        how = "symlink";
      }
    ];

    files = [
      ".bash_history" # Bash
      ".ssh/known_hosts" # SSH
      ".local/share/nix/trusted-settings.json"
      ".local/state/lazygit/state.yml"
    ]
    ++ lib.optionals osConfig.liuxu.system.better-shell.enable [
      ".local/share/fish/fish_history" # Fish
    ];
  };
}

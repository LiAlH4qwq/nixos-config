{ lib, osConfig, ... }:
{
  options.liuxu.home.internal.preservation =
    let
      o = {
        internal = true;
        type = with lib.types; listOf unspecified;
      };
    in
    {
      directories = lib.mkOption o;
      files = lib.mkOption o;
    };

  config.liuxu.home.internal.preservation = {
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

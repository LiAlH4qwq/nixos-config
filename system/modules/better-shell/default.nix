{ lib, ... }:
{
  imports = [
    ./bat
    ./eza
    ./fish
    ./starship
    ./zoxide
  ];

  options.liuxu.system.better-shell.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    example = false;
    description = ''
      Whether to enable the better shell.
        Currently enables fish, set it to default shell for all users,
        enables starship, enables its shell integration for all shells,
        enables zoxide, enables its shell integration (`z` command) for fish and bash,
        enables bat, eza, and set fish and bash aliases:
        cat --> bat
        ls --> eza
    '';
  };
}

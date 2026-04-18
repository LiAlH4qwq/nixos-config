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
        Currently enables fish, set it to default shell for all user,
        enables starship, enables its shell integration for all shells,
        enables zoxide, enables its fish integration (`z` command),
        enables bat, eza, and set fish aliases:
        cat --> bat
        ls --> eza
    '';
  };
}

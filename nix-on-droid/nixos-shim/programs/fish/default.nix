{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs.fish =
    let
      desc = lib.liuxu.mkDroidDesc;
    in
    {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = desc ''
          Ported from NixOS options.
        '';
      };
      shellInit = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = "set fish_greeting";
        description = desc ''
          Ported from NixOS options.
        '';
      };
      shellAliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          cat = "bat";
        };
        description = desc ''
          Ported from NixOS options.
        '';
      };
    };

  config = lib.mkIf config.programs.fish.enable {
    environment = {
      systemPackages = with pkgs; [ fish ];
      etc = {
        fish-init = {
          target = "fish/conf.d/10-init.fish";
          text = config.programs.fish.shellInit;
        };
        fish-aliases = {
          target = "fish/conf.d/50-aliases.fish";
          text =
            config.programs.fish.shellAliases
            |> lib.attrsToList
            |> map (nvp: "alias ${nvp.name} ${nvp.value}")
            |> builtins.concatStringsSep "\n";
        };
      };
    };
  };
}

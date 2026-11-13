{ config, lib, ... }: {
  options.programs.bash.shellAliases =
    let
      desc = lib.liuxu.mkDroidDesc;
    in
    lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        cat = "bat";
      };
      description = desc ''
        Ported from NixOS options.
      '';
    };

  config.environment.etc.bashrc.text =
    config.programs.bash.shellAliases
    |> lib.attrsToList
    |> map (nvp: "alias ${nvp.name}=${nvp.value}")
    |> builtins.concatStringsSep "\n";
}

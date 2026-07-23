{ config, lib, ... }: {
  options.programs.bash.shellAliases = lib.mkOptions {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    example = {
      cat = "bat";
    };
    description = ''
      Liuxu (Droid): Ported from NixOS options.
    '';
  };

  config.etc.bashrc.text =
    config.programs.bash.shellAliases
    |> lib.attrsToList
    |> map (nvp: "alias ${nvp.name}=${nvp.value}")
    |> builtins.concatStringsSep "\n";
}

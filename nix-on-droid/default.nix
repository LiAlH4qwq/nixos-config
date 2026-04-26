{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    "${inputs.self}/system"
    ./proot
  ];

  options.environment.systemPackages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    example = with pkgs; [ git ];
    description = ''
      Alias of `environment.packages`,
        to make some NixOS module effects here.
    '';
  };

  config = {
    environment.packages = config.environment.systemPackages;
  };
}

{
  config,
  lib,
  ...
}:
{
  options.liuxu.nixos.flatpak.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable the Flatpak support.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.flatpak.enable {
    services.flatpak.enable = true;
    intransience.datastores.persist.dirs = [ "/var/lib/flatpak" ];
  };
}

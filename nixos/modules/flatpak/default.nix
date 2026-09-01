{
  config,
  lib,
  ...
}:
{
  options.liuxu.nixos.flatpak.enable = lib.liuxu.mkOsSwitchOnOption ''
    Whether to enable the Flatpak support.
  '';

  config = lib.mkIf config.liuxu.nixos.flatpak.enable {
    services.flatpak.enable = true;
    intransience.datastores.persist.dirs = [ "/var/lib/flatpak" ];
  };
}

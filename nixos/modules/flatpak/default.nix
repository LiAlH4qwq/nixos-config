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
    preservation.preserveAt.persist.directories = [ "/var/lib/flatpak" ];
  };
}

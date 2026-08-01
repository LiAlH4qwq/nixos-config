{
  lib,
  osConfig,
  ...
}:
{

  config = lib.mkIf osConfig.liuxu.nixos.flatpak.enable {
    liuxu.home.internal.intransience.dirs = [
      ".local/share/flatpak"
      ".var/app"
    ];
  };
}

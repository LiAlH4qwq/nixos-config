{
  lib,
  osConfig,
  ...
}:
{

  config = lib.mkIf osConfig.liuxu.nixos.flatpak.enable {
    liuxu.home.internal.preservation.directories = [
      ".local/share/flatpak"
      ".var/app"
    ];
  };
}

{
  lib,
  osConfig,
  ...
}:
{

  config = lib.mkIf osConfig.liuxu.nixos.flatpak.enable {
    liuxu.home.preservation.directories = [
      ".local/share/flatpak"
      ".var/app"
    ];
  };
}

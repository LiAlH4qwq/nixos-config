_: {
  here.config = {
    services.flatpak.enable = true;
    preservation.preserveAt.persist.directories = [ "/var/lib/flatpak" ];
  };
}

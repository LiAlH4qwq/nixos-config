_: {
  here = {
    switch.generate = true;
    apply = {
      services.flatpak.enable = true;
      preservation.preserveAt.persist.directories = [ "/var/lib/flatpak" ];
    };
  };
}

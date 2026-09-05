_: {
  services.btrbk.instances.default = {
    settings = {
      preserve_day_of_week = "saturday";
      preserve_hour_of_day = "20";

      snapshot_preserve = "7w 12m";
      snapshot_preserve_min = "7d";

      stream_compress = "zstd";
      stream_compress_adapt = "yes";
      stream_compress_long = "default";

      warn_unknown_targets = "yes";

      target = "/mnt/btrbk/local";

      volume."/mnt/btrbk/root".subvolume = "@persist";
    };
  };
}

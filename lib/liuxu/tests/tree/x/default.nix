{ lib, ... }:
{
  here = {
    switch = {
      default = true;
      premise = [ "base" ];
    };
    options.marker = lib.mkOption {
      type = lib.types.str;
      default = "off";
    };
    config.liuxu.app.x.marker = "on";
  };
}

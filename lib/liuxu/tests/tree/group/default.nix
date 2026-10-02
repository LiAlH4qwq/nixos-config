{ lib, ... }:
{
  here = {
    switch = {
      default = true;
      children = {
        mode = "any";
        of = [
          "c1"
          "c2"
        ];
      };
    };
    options.gmark = lib.mkOption {
      type = lib.types.str;
      default = "off";
    };
    config.liuxu.app.group.gmark = "on";
  };
}

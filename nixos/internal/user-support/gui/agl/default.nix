{ inputs, ... }:
{
  imports = [ inputs.agl.nixosModules.default ];

  here = {
    switch = {
      default = true;
      premise = [
        {
          scope = "home";
          path = [
            "gui"
            "agl"
          ];
        }
      ];
    };
    config.networking.mihoyo-telemetry.block = true;
  };
}

{ inputs, ... }:
{
  imports = [ inputs.agl.nixosModules.default ];

  here = {
    switch = {
      generate = true;
      default = true;
      premise = {
        scope = "home";
        path = [
          "gui"
          "agl"
        ];
      };
    };
    apply.networking.mihoyo-telemetry.block = true;
  };
}

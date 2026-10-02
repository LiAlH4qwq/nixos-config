{ inputs, ... }:
{
  imports = [ inputs.umbriel.nixosModules.default ];

  here = {
    switch = {
      default = true;
      premise = [
        {
          scope = "home";
          path = [
            "gui"
            "umbriel"
          ];
        }
      ];
    };
    config.programs.umbriel.enable = true;
  };
}

{ inputs, ... }:
{
  imports = [ inputs.umbriel.nixosModules.default ];

  here = {
    switch = {
      generate = true;
      default = true;
      premise = {
        scope = "home";
        path = [
          "gui"
          "umbriel"
        ];
      };
    };
    apply.programs.umbriel.enable = true;
  };
}
